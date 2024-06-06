#!/bin/bash

# 전화번호부 파일
PHONEBOOK="phonebook.txt"

# 지역번호와 지역명 
get_area() {
    case "$1" in
        02) echo "서울";;
        031) echo "경기";;
        032) echo "인천";;
        051) echo "부산";;
        053) echo "대구";;
        *) echo "";; # 없는 지역번호
    esac
}

# 인수 확인
if [ "$#" -lt 2 ]; then
    echo "사용법: $0 <search|add> <이름> [전화번호]"
    exit 1
fi

# 동작 확인
ACTION="$1"
NAME="$2"
PHONE="$3"

# 전화번호 검색 기능
if [ "$ACTION" == "search" ]; then
    if [ "$#" -ne 2 ]; then
        echo "사용법: $0 search <이름>"
        exit 1
    fi
    if grep -q "^$NAME " "$PHONEBOOK"; then
        grep "^$NAME " "$PHONEBOOK"
    else
        echo "$NAME: 전화번호부에 존재하지 않습니다."
    fi
    exit 0
fi

# 전화번호 추가/수정 기능
if [ "$ACTION" == "add" ]; then
    if [ "$#" -ne 3 ]; then
        echo "사용법: $0 add <이름> <전화번호>"
        exit 1
    fi

    # 전화번호 형식 검사
    if ! [[ "$PHONE" =~ ^[0-9]{2,4}-[0-9]{3,4}-[0-9]{4}$ ]]; then
        echo "잘못된 전화번호 형식입니다."
        exit 2
    fi

    # 지역명 확인
    AREA_CODE=$(echo "$PHONE" | cut -d- -f1)
    AREA=$(get_area "$AREA_CODE")

    if [ -z "$AREA" ]; then
        echo "알 수 없는 지역번호입니다: $AREA_CODE"
        exit 3
    fi

    # 전화번호부에 이름 검색
    if grep -q "^$NAME " "$PHONEBOOK"; then
        EXISTING_PHONE=$(grep "^$NAME " "$PHONEBOOK" | awk '{print $2}')
        if [ "$EXISTING_PHONE" == "$PHONE" ]; then
            echo "$NAME: 동일한 전화번호가 이미 존재합니다."
            exit 0
        else
            # 기존 전화번호를 업데이트
            sed -i "/^$NAME /c\\$NAME $PHONE $AREA" "$PHONEBOOK"
            echo "$NAME: 전화번호 업데이트 완료."
        fi
    else
        # 새로운 항목 추가
        echo "$NAME $PHONE $AREA" >> "$PHONEBOOK"
        echo "$NAME: 전화번호 추가 완료."
    fi

    # 전화번호부 정렬
    sort -o "$PHONEBOOK" "$PHONEBOOK"

    exit 0
fi

# 잘못된 동작
echo "사용법: $0 <search|add> <이름> [전화번호]"
exit 1
