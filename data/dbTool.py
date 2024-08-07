import json
import re
from datetime import datetime

def clean_json_string(json_str):
    # 제어 문자 제거
    json_str = re.sub(r'[\x00-\x1f\x7f-\x9f]', '', json_str)
    return json_str

# JSON 파일 읽기
with open('filtered.json', 'r', encoding='utf-8') as infile:
    dbData = json.load(infile)

# "value" 값을 문자열에서 JSON 객체로 변환
for item in dbData['data']:
    if 'value' in item:
        clean_value = clean_json_string(item['value'])
        item['value'] = json.loads(clean_value)

# JSON 파일 읽기
with open('raw.json', 'r', encoding='utf-8') as infile:
    newData = json.load(infile)

# "value" 값을 문자열에서 JSON 객체로 변환
for item in newData['data']:
    if 'value' in item:
        clean_value = clean_json_string(item['value'])
        item['value'] = json.loads(clean_value)

        # {
        #     "FILTERED_ID": 10,
        #     "createdDate": "2024-07-22 21:21:00",
        #     "_key": "rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq -",
        #     "memo": "2. Scandinavian Defense",
        #     "status": null,
        #     "value": {
        #         "title": "Scandinavian Defense",
        #         "moves": [
        #             {
        #                 "title": "",
        #                 "pgn": "exd5",
        #                 "info": " 백이 이점을 얻을 수 있는 유일한 수이다.",
        #                 "type": 0
        #             },
        #             {
        #                 "title": "Dunst Opening: Main Line",
        #                 "type": 4,
        #                 "pgn": "Nc3",
        #                 "info": " 나이트를 전개해서 e4폰을 지킨다. 그러나 2…d4로 흑이 공간을 확보하고 템포를 벌 수 있기 때문에 좋지 않다."
        #             }
        #         ],
        #         "info": " 백의 e4폰을 흑이 바로 d5로 카운터한다. 백은 exd5가 강제된다. 이후 흑은 폰을 회수하는 과정에서 템포 손해를 보게 된다."
        #     }
        # },

compareResult = {}

for newItem in newData['data']:
    print(newItem['memo'])
    compare = {"title": {}, "info": {}, "moves": []}
    compare['title']['raw'] = newItem['value']['title']
    compare['info']['raw'] = newItem['value']['info']
    for i in newItem['value']['moves'] :
        move = {"title": {}, "info": {}, "type": {}}
        move['pgn'] = i['pgn']
        move['title']['raw'] = i['title']
        move['info']['raw'] = i['info']
        move['type']['raw'] = i['type']
        compare['moves'].append(move)

    for dbItem in dbData['data']:
        if dbItem['_key'] == newItem['memo'] :
            print(dbItem['memo'])
            compare['title']['filtered'] = dbItem['value']['title']
            compare['info']['filtered'] = dbItem['value']['info']
            for i in dbItem['value']['moves'] :
                isIn = False
                for j in compare['moves'] :
                    if i["pgn"] == j["pgn"] :
                        isIn = True
                        j["title"]["filtered"] = i["title"]
                        j["info"]["filtered"] = i["info"]
                        j["type"]["filtered"] = i["type"]
                if not isIn :
                    move = {"title": {}, "info": {}, "type": {}}
                    move['pgn'] = i['pgn']
                    move['title']['filtered'] = i['title']
                    move['info']['filtered'] = i['info']
                    move['type']['filtered'] = i['type']
                    compare['moves'].append(move)
            break
            # print("Filtered : " + dbItem['value']['title'])
            # print("Raw : " + newItem['value']['title'])
            # print("Select. (0: Filtered, 1: Raw) => ", end="")
            # int(input()) == 0 
            # print(dbItem['memo'])
    compareResult[newItem['memo']] = compare
    # print(newItem)

with open(f'compare.json', 'w', encoding='utf-8') as outfile:
    json.dump(compareResult, outfile, ensure_ascii=False, indent=4)

result = {"moves": []}

for key in compareResult.keys() :
    
    print("Filtered : " + compareResult[key]['title']['filtered'])
    print("Raw      : " + compareResult[key]['title']['raw'])
    print("Select. (0: Filtered, 1: Raw) => ", end="")
    result['title'] = compareResult[key]['title']['filtered'] if int(input()) == 0 else compareResult[key]['title']['raw']

    print("Filtered : " + compareResult[key]['info']['filtered'])
    print("Raw      : " + compareResult[key]['info']['raw'])
    print("Select. (0: Filtered, 1: Raw) => ", end="")
    result['info'] = compareResult[key]['info']['filtered'] if int(input()) == 0 else compareResult[key]['info']['raw']
    
    for pgn in compareResult[key]['moves'] :
        temp = {}
        print("Filtered : " + compareResult[key]['title']['filtered'])
        print("Raw      : " + compareResult[key]['title']['raw'])
        print("Select. (0: Filtered, 1: Raw) => ", end="")
        result['title'] = compareResult[key]['title']['filtered'] if int(input()) == 0 else compareResult[key]['title']['raw']


    print("Filtered : " + compareResult[key]['title']['filtered'])
    print("Raw      : " + newItem['value']['title']['raw'])
    print("Select. (0: Filtered, 1: Raw) => ", end="")
    result['title'] = compareResult[key]['title']['filtered'] if int(input()) == 0 else newItem['value']['title']['raw']
    
# print("JSON 파일이 성공적으로 변환 및 저장되었습니다.")