/*
  Stockfish in iOS
  
  
*/
#import "StockfishWrapper.h"
#include "bitboard.h"
#include "evaluate.h"
#include "misc.h"
#include "position.h"
#include "tune.h"
#include "types.h"
#include "uci.h"
#include "engine.h"

@interface StockfishWrapper ()
{
    int inputPipe[2];
    int outputPipe[2];
    Stockfish::UCIEngine *uci;
}
@property (nonatomic, strong) NSThread *engineThread;
@property (nonatomic, assign) BOOL isReady;
@end

@implementation StockfishWrapper

- (instancetype)init {
    self = [super init];
    if (self) {
        if (pipe(inputPipe) == -1) {
            perror("input pipe creation failed");
        }
        if (pipe(outputPipe) == -1) {
            perror("output pipe creation failed");
        }
        self.engineThread = [[NSThread alloc] initWithTarget:self selector:@selector(runEngine) object:nil];
        self.isReady = NO;
    }
    return self;
}

- (void)startEngine {
    NSLog(@"Starting engine");
    [self.engineThread start];
    [NSThread detachNewThreadSelector:@selector(readOutput) toTarget:self withObject:nil];
}

- (void)runEngine {
    NSLog(@"Running engine");
    dup2(inputPipe[0], STDIN_FILENO);
    
    setvbuf(stdout, nil, _IONBF, 0);
    dup2(outputPipe[1], STDOUT_FILENO);

    Stockfish::Bitboards::init();
    Stockfish::Position::init();
    
    int argc = 1;
    const char* argv[] = {"stockfish"};
    uci = new Stockfish::UCIEngine(argc, (char**)argv);
    Stockfish::Tune::init(uci->engine_options());
    uci->loop();
}

- (void)sendCommand:(NSString *)command {
    
    [self sendStopCommand];
    
    NSLog(@"Sending command: %@", command);
    NSArray<NSString *> *commands = [command componentsSeparatedByString:@";"];
    for (NSString *cmd in commands) {
        NSString *cmdWithNewline = [cmd stringByAppendingString:@"\n"];
        ssize_t bytesWritten = write(inputPipe[1], [cmdWithNewline UTF8String], [cmdWithNewline lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
        if (bytesWritten == -1) {
            perror("Error writing to inputPipe");
        } else {
            NSLog(@"Successfully wrote %zd bytes to inputPipe", bytesWritten);
        }
    }
}

- (void)sendStopCommand {
    NSString *stopCommand = @"stop\n";
    ssize_t bytesWritten = write(inputPipe[1], [stopCommand UTF8String], [stopCommand lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    if (bytesWritten == -1) {
        perror("Error writing to inputPipe");
    } else {
        NSLog(@"Successfully sent stop command to engine.");
    }
}

- (void)readOutput {
    char buffer[256];
    ssize_t count;
    
    while (true) {
        count = read(outputPipe[0], buffer, sizeof(buffer) - 1);
        if (count > 0) {
            buffer[count] = '\0';
            NSString *output = [NSString stringWithUTF8String:buffer];
//            NSLog(@"In objc @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
//            NSLog(@"%@", output);
            if ([output containsString:@"Essence"] && self.onResponse) {
                NSLog(@"%@", output);
                self.onResponse([output copy]);
            }
        }
    }
}

@end
