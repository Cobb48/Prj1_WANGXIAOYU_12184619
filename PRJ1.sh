 #!/bin/bash

get_movie_data_by_id() {
  grep "^$1|" u.item
}

get_action_movies() {
  grep "|Action|" u.item
}

get_average_rating_by_movie_id() {
  awk -F"\t" '$2 == id { total += $3; count++ } END { if (count > 0) print total/count; else print "No ratings found." }' id="$1" u.data
}

remove_imdb_url() {
  cut -f1-4,6- u.item > u.item.new && mv u.item.new u.item
}

get_user_data() {
  cat u.user
}

convert_release_date_format() {
  awk -F'|' 'BEGIN { OFS = FS } { split($3, d, "-"); $3 = d[3] "-" d[2] "-" d[1]; print }' u.item > u.item.new && mv u.item.new u.item
}

get_movie_data_by_user_id() {
  awk -F"\t" '$1 == user_id { print }' user_id="$1" u.data
}

get_average_rating_by_programmers() {
  awk -F"|" 'NR==FNR && $3 >= 20 && $3 <= 29 && $4 == "programmer" { programmers[$1] } NR!=FNR && ($1 in programmers) { total += $3; count++ } END { if (count > 0) print total/count; else print "No ratings found." }' u.user u.data
}


while true; do
  echo "선택 항목을 입력:[1-9]:"
  read choice
  case $choice in
    1)
      echo ""영화 ID"를 입력:(1~1682):"
      read movie_id
      get_movie_data_by_id "$movie_id"
      ;;
    2)
      get_action_movies
      ;;
    3)
      echo ""영화 ID"를 입력:(1~1682):"
      read movie_id
      get_average_rating_by_movie_id "$movie_id"
      ;;
    4)
      remove_imdb_url
      ;;
    5)
      get_user_data
      ;;
    6)
      convert_release_date_format
      ;;
    7)
      echo ""USER ID"를 입력:"
      read user_id
      get_movie_data_by_user_id "$user_id"
      ;;
    8)
      get_average_rating_by_programmers
      ;;
    9)
      echo "프로그램을 종료하세요"
      break
      ;;
    *)
      echo "선택이 잘못되었습니다. 1~9 사이의 숫자를 입력하세요."
      ;;
  esac
done