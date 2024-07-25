import json
import re
from datetime import datetime

def clean_json_string(json_str):
    # 제어 문자 제거
    json_str = re.sub(r'[\x00-\x1f\x7f-\x9f]', '', json_str)
    return json_str

# JSON 파일 읽기
with open('filtered.json', 'r', encoding='utf-8') as infile:
    data = json.load(infile)

# "value" 값을 문자열에서 JSON 객체로 변환
for item in data['data']:
    if 'value' in item:
        clean_value = clean_json_string(item['value'])
        item['value'] = json.loads(clean_value)

# 현재 날짜와 시간을 기반으로 파일 이름 생성
current_time = datetime.now().strftime("%Y%m%d_%H%M%S")

# 다른 이름으로 JSON 파일 저장하기
with open(f'backup{current_time}.json', 'w', encoding='utf-8') as outfile:
    json.dump(data, outfile, ensure_ascii=False, indent=4)

print("JSON 파일이 성공적으로 변환 및 저장되었습니다.")