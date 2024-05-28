#!/bin/bash

# 윤년인지 아닌지
is_leap_year() { # 윤년 leap_year

    year=$1
    if (( year % 4 != 0 )); then # 평년
        echo 0
    elif (( year % 400 == 0 )); then # 윤년
        echo 1
    elif (( year % 100 == 0 )); then # 평년
        echo 0
    else # 윤년년
        echo 1
    fi
}

# 인수가 3개가 아닌 경우 종료
if [ $# -ne 3 ]; then 
    echo "입력값 오류"
    exit 1
fi

# 입력값
month_input=$1
day=$2
year=$3

# 대문자 변환 함수
convert_month() {
    case "$1" in
        "jan"|"january"|"Jan"|"January"|1) echo "Jan";;
        "feb"|"february"|"Feb"|"February"|2) echo "Feb";;
        "mar"|"march"|"Mar"|"March"|3) echo "Mar";;
        "apr"|"april"|"Apr"|"April"|4) echo "Apr";;
        "may"|"May"|5) echo "May";;
        "jun"|"june"|"Jun"|"June"|6) echo "Jun";;
        "jul"|"july"|"Jul"|"July"|7) echo "Jul";;
        "aug"|"august"|"Aug"|"August"|8) echo "Aug";;
        "sep"|"september"|"Sep"|"September"|9) echo "Sep";;
        "oct"|"october"|"Oct"|"October"|10) echo "Oct";;
        "nov"|"november"|"Nov"|"November"|11) echo "Nov";;
        "dec"|"december"|"Dec"|"December"|12) echo "Dec";;
        *) echo "Invalid";;
    esac
}

# 입력값 월 대문자 변환
month=$(convert_month "$month_input")

# 입력값 윤년 판별
leap_year=$(is_leap_year $year)

# 각 달의 일 수 설정
# 변수가 1이면 윤년 0이면 평
if [ "$leap_year" -eq 1 ]; then
# 1월부터 12월까지 일수를 설정 (2월은 29일)
    days_in_month=(0 31 29 31 30 31 30 31 31 30 31 30 31)
# 2월이 28일까지일 경우(0번째 인덱스는 0)
else
    days_in_month=(0 31 28 31 30 31 30 31 31 30 31 30 31)
fi

# ---------------- 이 부분은 잘 몰랐는데 오류나서 GPT로 수정 받음
# 월을 숫자로 변환 (위의 인덱스에 넣기 위해)
month_num=$(date -d "1 $month" +"%m")

# 일자 유효성 검사 ( 입력받은 day 값이 위에서 설정한 최대 일수보다 큰지 비교)
if [ $day -lt 1 ] || [ $day -gt ${days_in_month[$month_num]} ]; then
    echo "$month $day $year는 유효하지 않습니다"
    exit 1
fi
# ----------------

# 날짜 출력
echo "$month $day $year"