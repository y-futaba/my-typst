#!/bin/bash

# 引数があるかチェック（引数がない場合は使い方を表示して終了）
if [ -z "$1" ]; then
    echo "Usage: $0 <output_file_path>"
    exit 1
fi

# 対象のファイルを指定
file1="template_image.typ"
file2="template_report.typ"
re='^#import "template_image'

# 出力先を第1引数から取得
output="$1"

# 配列を初期化
declare -a importLines
declare -a otherLines

# ファイルを1行ずつ読み込む
while IFS= read -r line; do
    # 行が "#import" で始まるか確認
    if [[ $line == \#import* ]]; then
        # 該当行を importLines 配列に追加
        importLines+=("$line")
    else
        # それ以外の行を otherLines 配列に追加
        otherLines+=("$line")
    fi
done <"$file1"

while IFS= read -r line; do
    # 行が "#import" で始まるか確認
    if [[ $line =~ $re ]]; then
        :
    elif [[ $line == \#import* ]]; then
        # 該当行を importLines 配列に追加
        importLines+=("$line")
    else
        # それ以外の行を otherLines 配列に追加
        otherLines+=("$line")
    fi
done <"$file2"

# 結果をファイルに書き出し
{
    for importLine in "${importLines[@]}"; do
        echo "$importLine"
    done

    for otherLine in "${otherLines[@]}"; do
        echo "$otherLine"
    done
} >"$output"

echo "Done! Saved to $output"
