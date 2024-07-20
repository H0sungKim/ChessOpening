//
//  ViewController.swift
//  ChessOpening
//
//  Created by 김호성 on 2024.05.23.
//



//  "FIDE Laws of Chess taking effect from 1 January 2023", FIDE, https://handbook.fide.com/chapter/E012023
// 
//  Article 1: The Nature and Objectives of the Game of Chess
// 
//    1.1     The game of chess is played between two opponents who move
//            their pieces on a square board called a ‘chessboard’.
// 
//    1.2     The player with the light-coloured pieces (White) makes
//            the first move, then the players move alternately, with
//            the player with the dark-coloured pieces (Black) making the next move.
// 
//    1.3     A player is said to ‘have the move’ when his/her opponent’s move has been ‘made’.
// 
//    1.4     The objective of each player is to place the opponent’s king
//            ‘under attack’ in such a way that the opponent has no legal move.
//        1.4.1    The player who achieves this goal is said to have ‘checkmated’
//                 the opponent’s king and to have won the game. Leaving one’s
//                 own king under attack, exposing one’s own king to attack
//                 and also ’capturing’ the opponent’s king is not allowed.
//
//        1.4.2    The opponent whose king has been checkmated has lost the game.
//
//    1.5     If the position is such that neither player can possibly checkmate
//            the opponent’s king, the game is drawn (see Article 5.2.2).
//
//
//  Article 2: The Initial Position of the Pieces on the Chessboard
// 
//    2.1     The chessboard is composed of an 8 x 8 grid of 64 equal squares
//            alternately light (the ‘white’ squares) and dark (the ‘black’ squares).
//            The chessboard is placed between the players in such a way
//            that the near corner square to the right of the player is white.
// 
//    2.2     At the beginning of the game White has 16 light-coloured pieces (the ‘white’ pieces);
//            Black has 16 dark-coloured pieces (the ‘black’ pieces).
// 
//                These pieces are as follows:
//                A white king            usually indicated by the symbol ♔ K
//                A white queen           usually indicated by the symbol ♕ Q
//                Two white rooks         usually indicated by the symbol ♖ R
//                Two white bishops       usually indicated by the symbol ♗ B
//                Two white knights       usually indicated by the symbol ♘ N
//                Eight white pawns       usually indicated by the symbol ♙
//                A black king            usually indicated by the symbol ♚ K
//                A black queen           usually indicated by the symbol ♛ Q
//                Two black rooks         usually indicated by the symbol ♜ R
//                Two black bishops       usually indicated by the symbol ♝ B
//                Two black knights       usually indicated by the symbol ♞ N
//                Eight black pawns       usually indicated by the symbol ♟︎
// 
//    2.3     The initial position of the pieces on the chessboard is as follows:
//                8 ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜
//                7 ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟
//                6
//                5
//                4
//                3
//                2 ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙
//                1 ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖
// 
//                  +---+---+---+---+---+---+---+---+
//                8 | R | N | B | Q | K | B | N | R |
//                  +---+---+---+---+---+---+---+---+
//                7 | P | P | P | P | P | P | P | P |
//                  +---+---+---+---+---+---+---+---+
//                6 |   |   |   |   |   |   |   |   |
//                  +---+---+---+---+---+---+---+---+
//                5 |   |   |   |   |   |   |   |   |
//                  +---+---+---+---+---+---+---+---+
//                4 |   |   |   |   |   |   |   |   |
//                  +---+---+---+---+---+---+---+---+
//                3 |   |   |   |   |   |   |   |   |
//                  +---+---+---+---+---+---+---+---+
//                2 | P | P | P | P | P | P | P | P |
//                  +---+---+---+---+---+---+---+---+
//                1 | R | N | B | Q | K | B | N | R |
//                  +---+---+---+---+---+---+---+---+
//                    a   b   c   d   e   f   g   h
// 
//    2.4     The eight vertical files of squares are called ‘files’.
//            The eight horizontal ranks of squares are called ‘ranks’.
//            A straight line of squares of the same colour, running from one edge
//            of the board to an adjacent edge, is called a ‘diagonal’.
// 
// 
//  Article 3: The Moves of the Pieces
// 
//    3.1     It is not permitted to move a piece to a square occupied
//            by a piece of the same colour.
// 
//        3.1.1    If a piece moves to a square occupied by an opponent’s piece the latter
//                 is captured and removed from the chessboard as part of the same move.
// 
//        3.1.2    A piece is said to attack an opponent’s piece if the piece could
//                 make a capture on that square according to Articles 3.2 to 3.8.
// 
//        3.1.3    A piece is considered to attack a square even if this piece is
//                 constrained from moving to that square because it would then leave
//                 or place the king of its own colour under attack.
// 
//    3.2     The bishop may move to any square along a diagonal on which it stands.
//            +---+---+---+---+---+---+---+---+
//            | * |   |   |   |   |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   | * |   |   |   |   |   | * |
//            +---+---+---+---+---+---+---+---+
//            |   |   | * |   |   |   | * |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   | * |   | * |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   |   | B |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   | * |   | * |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   | * |   |   |   | * |   |
//            +---+---+---+---+---+---+---+---+
//            |   | * |   |   |   |   |   | * |
//            +---+---+---+---+---+---+---+---+
// 
//    3.3     The rook may move to any square along the file or the rank on which it stands.
//            +---+---+---+---+---+---+---+---+
//            |   |   |   | * |   |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   | * |   |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   | * |   |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   | * |   |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   | * |   |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            | * | * | * | R | * | * | * | * |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   | * |   |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   | * |   |   |   |   |
//            +---+---+---+---+---+---+---+---+
// 
//    3.4     The queen may move to any square along the file, the rank or a diagonal
//            on which it stands.
//            +---+---+---+---+---+---+---+---+
//            | * |   |   |   | * |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   | * |   |   | * |   |   | * |
//            +---+---+---+---+---+---+---+---+
//            |   |   | * |   | * |   | * |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   | * | * | * |   |   |
//            +---+---+---+---+---+---+---+---+
//            | * | * | * | * | Q | * | * | * |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   | * | * | * |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   | * |   | * |   | * |   |
//            +---+---+---+---+---+---+---+---+
//            |   | * |   |   | * |   |   | * |
//            +---+---+---+---+---+---+---+---+
// 
//    3.5     When making these moves, the bishop, rook or queen may not move
//            over any intervening pieces.
// 
//    3.6     The knight may move to one of the squares nearest to that on which
//            it stands but not on the same rank, file or diagonal.
//            +---+---+---+---+---+---+---+---+
//            |   |   |   |   |   | B | N | R |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   |   | * | P | P | P |
//            +---+---+---+---+---+---+---+---+
//            |   |   |   |   |   | * |   | * |
//            +---+---+---+---+---+---+---+---+
//            |   | * |   | * |   |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            | * |   |   |   | * |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   |   | N |   |   |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            | * |   |   |   | * |   |   |   |
//            +---+---+---+---+---+---+---+---+
//            |   | * |   | * |   |   |   |   |
//            +---+---+---+---+---+---+---+---+
// 
//    3.7     The pawn:
// 
//        3.7.1    The pawn may move forward to the square immediately in front of
//                 it on the same file, provided that this square is unoccupied, or
// 
//        3.7.2    on its first move the pawn may move as in 3.7.1 or alternatively
//                 it may advance two squares along the same file, provided
//                 that both squares are unoccupied, or
// 
//        3.7.3    the pawn may move to a square occupied by an opponent’s piece
//                 diagonally in front of it on an adjacent file, capturing that piece.
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   | P |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   | * |   |   | X | * | X |
//                 +---+---+---+---+---+---+---+---+
//                 |   | X | * | X |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   | P |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
// 
//            3.7.3.1    A pawn occupying a square on the same rank as and on an
//                       adjacent file to an opponent’s pawn which has just advanced
//                       two squares in one move from its original square may capture
//                       this opponent’s pawn as though the latter had been moved
//                       only one square.
// 
//            3.7.3.2    This capture is only legal on the move following this
//                       advance and is called an ‘en passant’ capture.
//                       +---+---+---+---+---+---+---+---+
//                       |   |   |   |   |   |   |   |   |
//                       +---+---+---+---+---+---+---+---+
//                       |   |   |   |   | P |   |   |   |
//                       +---+---+---+---+---+---+---+---+
//                       |   |   |   |   | X |   |   |   |
//                       +---+---+---+---+---+---+---+---+
//                       |   |   |   | P | * |   |   |   |
//                       +---+---+---+---+---+---+---+---+
//                       |   |   |   |   |   |   |   |   |
//                       +---+---+---+---+---+---+---+---+
//                       |   |   |   |   |   |   |   |   |
//                       +---+---+---+---+---+---+---+---+
//                       |   |   |   |   |   |   |   |   |
//                       +---+---+---+---+---+---+---+---+
//                       |   |   |   |   |   |   |   |   |
//                       +---+---+---+---+---+---+---+---+
// 
//            3.7.3.3    When a player, having the move, plays a pawn to the rank
//                       furthest from its starting position, he/she must exchange
//                       that pawn as part of the same move for a new queen, rook,
//                       bishop or knight of the same colour on the intended square
//                       of arrival. This is called the square of ‘promotion’.
// 
//            3.7.3.4    The player's choice is not restricted to pieces that have
//                       been captured previously.
// 
//            3.7.3.5    This exchange of a pawn for another piece is called promotion,
//                       and the effect of the new piece is immediate.
// 
//    3.8     There are two different ways of moving the king:
// 
//        3.8.1    by moving to an adjoining square
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   | * | K | * |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   | * | * | * |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   | * | * | * |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   | * | K | * |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   | * | * | * |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
// 
//        3.8.2    by ‘castling’. This is a move of the king and either rook of the
//                 same colour along the player’s first rank, counting as a single
//                 move of the king and executed as follows: the king is transferred
//                 from its original square two squares towards the rook on its
//                 original square, then that rook is transferred to the square
//                 the king has just crossed.
// 
//                 +---+---+---+---+---+---+---+---+
//                 | R |   |   |   | K |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   | K |   |   | R |
//                 +---+---+---+---+---+---+---+---+
//                 Before white kingside castling
//                 Before black queenside castling
// 
//                 +---+---+---+---+---+---+---+---+
//                 |   |   | K | R |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   | R | K |   |
//                 +---+---+---+---+---+---+---+---+
//                 After white kingside castling
//                 After black queenside castling
// 
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   | K |   |   | R |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 | R |   |   |   | K |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 Before white queenside castling
//                 Before black kingside castling
// 
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   | R | K |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   |   |   |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 |   |   | K | R |   |   |   |   |
//                 +---+---+---+---+---+---+---+---+
//                 After white queenside castling
//                 After black kingside castling
// 
//            3.8.2.1    The right to castle has been lost:
// 
//                1) If the king has already moved, or
//                2) With a rook that has already moved.
// 
//            3.8.2.2    Castling is prevented temporarily:
// 
//                3) If the square on which the king stands, or the square which
//                it must cross, or the square which it is to occupy, is attacked
//                by one or more of the opponent's pieces, or
//                4) If there is any piece between the king and the rook with which
//                castling is to be effected.
// 
//    3.9     The king in check:
// 
//        3.9.1    The king is said to be 'in check' if it is attacked by one or
//                 more of the opponent's pieces, even if such pieces are constrained
//                 from moving to the square occupied by the king because they would
//                 then leave or place their own king in check.
// 
//        3.9.2    No piece can be moved that will either expose the king of the
//                 same colour to check or leave that king in check.
// 
//    3.10   Legal and illegal moves; illegal positions:
// 
//        3.10.1    A move is legal when all the relevant requirements of
//                  Articles 3.1 – 3.9 have been fulfilled.
// 
//        3.10.2    A move is illegal when it fails to meet the relevant requirements
//                  of Articles 3.1 – 3.9.
// 
//        3.10.3    A position is illegal when it cannot have been reached by any
//                  series of legal moves.
// 
// 
//  Article 4: The Act of Moving the Pieces
// 
//    4.1     Each move must be played with one hand only.
// 
//    4.2     Adjusting the pieces or other physical contact with a piece:
// 
//        4.2.1    Only the player having the move may adjust one or more pieces
//                 on their squares, provided that he/she first expresses his/her
//                 intention (for example by saying “j’adoube” or “I adjust”).
// 
//        4.2.2    Any other physical contact with a piece, except for clearly
//                 accidental contact, shall be considered to be intent.
// 
//    4.3     Except as provided in Article 4.2.1, if the player having the move
//            touches on the chessboard, with the intention of moving or capturing:
// 
//        4.3.1    one or more of his/her own pieces, he/she must move the first
//                 piece touched that can be moved.
// 
//        4.3.2    one or more of his/her opponent’s pieces, he/she must capture
//                 the first piece touched that can be captured.
// 
//        4.3.3    one or more pieces of each colour, he/she must capture the first
//                 touched opponent’s piece with his/her first touched piece or,
//                 if this is illegal, move or capture the first piece touched that
//                 can be moved or captured. If it is unclear whether the player’s
//                 own piece or his/her opponent’s piece was touched first, the
//                 player’s own piece shall be considered to have been touched
//                 before his/her opponent’s.
// 
//    4.4     If a player having the move:
// 
//        4.4.1    touches his/her king and a rook he/she must castle on that side
//                 if it is legal to do so
// 
//        4.4.2    deliberately touches a rook and then his/her king he/she is not
//                 allowed to castle on that side on that move and the situation
//                 shall be governed by Article 4.3.1.
// 
//        4.4.3    intending to castle, touches the king and then a rook, but castling
//                 with this rook is illegal, the player must make another legal
//                 move with his/her king (which may include castling with the other
//                 rook). If the king has no legal move, the player is free to make
//                 any legal move.
// 
//        4.4.4    promotes a pawn, the choice of the piece is finalised when the
//                 piece has touched the square of promotion.
// 
//    4.5     If none of the pieces touched in accordance with Article 4.3 or Article 4.4
//            can be moved or captured, the player may make any legal move.
// 
//    4.6     The act of promotion may be performed in various ways:
// 
//        4.6.1    the pawn does not have to be placed on the square of arrival.
// 
//        4.6.2    removing the pawn and putting the new piece on the square of
//                 promotion may occur in any order.
// 
//        4.6.3    If an opponent’s piece stands on the square of promotion, it
//                 must be captured.
// 
//    4.7     When, as a legal move or part of a legal move, a piece has been
//            released on a square, it cannot be moved to another square on this move.
//            The move is considered to have been made in the case of:
// 
//        4.7.1    A capture, when the captured piece has been removed from the
//                 chessboard and the player, having placed his/her own piece on its
//                 new square, has released this capturing piece from his/her hand.
// 
//        4.7.2    Castling, when the player's hand has released the rook on the
//                 square previously crossed by the king. When the player has released
//                 the king from his/her hand, the move is not yet made, but the
//                 player no longer has the right to make any move other than castling
//                 on that side, if this is legal. If castling on this side is illegal,
//                 the player must make another legal move with his/her king (which
//                 may include castling with the other rook). If the king has no legal
//                 move, the player is free to make any legal move.
// 
//        4.7.3    Promotion, when the player's hand has released the new piece on
//                 the square of promotion and the pawn has been removed from the board.
// 
//    4.8     A player forfeits his/her right to claim against his/her opponent’s
//            violation of Articles 4.1 – 4.7 once the player touches a piece with
//            the intention of moving or capturing it.
// 
//    4.9     If a player is unable to move the pieces, an assistant, who shall be
//            acceptable to the arbiter, may be provided by the player to perform
//            this operation.
// 
// 
//  Article 5: The Completion of the Game
// 
//        5.1.1    The game is won by the player who has checkmated his/her opponent’s
//                 king. This immediately ends the game, provided that the move
//                 producing the checkmate position was in accordance with Article 3
//                 and Articles 4.2 – 4.7.
// 
//        5.1.2    The game is lost by the player who declares he/she resigns
//                 (this immediately ends the game), unless the position is such
//                 that the opponent cannot checkmate the player’s king by any
//                 possible series of legal moves. In this case the result of the
//                 game is a draw.
// 
//        5.2.1    The game is drawn when the player to move has no legal move and
//                 his/her king is not in check. The game is said to end in ‘stalemate’.
//                 This immediately ends the game, provided that the move producing
//                 the stalemate position was in accordance with Article 3 and Articles 4.2 – 4.7.
// 
//        5.2.2    The game is drawn when a position has arisen in which neither
//                 player can checkmate the opponent’s king with any series of legal
//                 moves. The game is said to end in a ‘dead position’. This immediately
//                 ends the game, provided that the move producing the position was
//                 in accordance with Article 3 and Articles 4.2 – 4.7.
// 
//        5.2.3    The game is drawn upon agreement between the two players during
//                 the game, provided both players have made at least one move.
//                 This immediately ends the game.

// TODO: audio
// TODO: piece diff
// TODO: Check, Stalemate, Checkmate
// TODO: Engine Refactoring


import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var chessBoardView: ChessBoardView!
    @IBOutlet weak var containerView: UIView!
    
    private var isEditInfo: Bool = false
    private var tabBarViewController: TabBarViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSLog("Build : 2024.07.20 22:36")
        
        chessBoardView.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        let containerChildViewController = UIViewController.getViewController(viewControllerEnum: .tabbar)
        addChild(containerChildViewController)
        containerChildViewController.view.frame = containerView.bounds
        containerView.addSubview(containerChildViewController.view)
        containerChildViewController.didMove(toParent: self)
        self.tabBarViewController = containerChildViewController as? TabBarViewController
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBarViewController?.infoViewController?.sheetHeight = containerView.bounds.height
        tabBarViewController?.infoViewController?.delegate = self
        tabBarViewController?.historyViewController?.delegate = self
        
        chessBoardDidUpdate(simpleFen: chessBoardView.engine.getSimpleFEN())
    }
}

extension MainViewController: ChessBoardViewDelegate {
    func chessBoardDidUpdate(simpleFen: String) {
        CommonRepository.shared.getFiltered(key: simpleFen)
            .subscribe(onSuccess: { [weak self] boardModel in
                guard let self = self else {
                    return
                }
                
                self.chessBoardView.moves = boardModel.moves
                if !self.chessBoardView.animationDrawFlag {
                    self.chessBoardView.setNeedsDisplay()
                }
                
                self.tabBarViewController?.infoViewController?.boardModel = boardModel
                self.tabBarViewController?.infoViewController?.initializeView()
            })
            .disposed(by: disposeBag)
        
        tabBarViewController?.infoViewController?.turn = chessBoardView.engine.getTurn()
        tabBarViewController?.infoViewController?.key = simpleFen
        tabBarViewController?.historyViewController?.history = chessBoardView.engine.pgn
        tabBarViewController?.historyViewController?.collectionView?.reloadData()
    }
}

extension MainViewController: InfoDelegate {
    func setPreviousTurn() {
        if chessBoardView.engine.turn-1 < 0 {
            return
        }
        chessBoardView.engine.turn = chessBoardView.engine.turn-1
        chessBoardView.engine.applyFEN(fen: chessBoardView.engine.fen[chessBoardView.engine.turn])
        chessBoardDidUpdate(simpleFen: chessBoardView.engine.getSimpleFEN())
    }
    func setNextTurn() {
        if chessBoardView.engine.turn+1 > chessBoardView.engine.pgn.count {
            return
        }
        chessBoardView.engine.turn = chessBoardView.engine.turn+1
        chessBoardView.engine.applyFEN(fen: chessBoardView.engine.fen[chessBoardView.engine.turn])
        chessBoardDidUpdate(simpleFen: chessBoardView.engine.getSimpleFEN())
    }
    func applyMove(pgn: String) {
        if let (move, promotionPiece) = chessBoardView.engine.convertPGNtoCoordinate(pgn: pgn) {
            chessBoardView.movePieceWithAnimation(move: move, promotionPiece: promotionPiece)
        }
    }
    func getLegalMovePGN() -> [String] {
        return chessBoardView.engine.legalMoves.map { chessBoardView.engine.getPGNWithoutCheck(move: $0) }
    }
}

extension MainViewController: HistoryDelegate {
    func pgnOnClick(turn: Int) {
        chessBoardView.engine.applyFEN(fen: chessBoardView.engine.fen[turn+1])
        chessBoardDidUpdate(simpleFen: chessBoardView.engine.getSimpleFEN())
    }
}
