
## 检查 Git 是否存在
git=$(which git)
[[ -x "$git" ]] || { printf "\e[1;31mGit Not Found,  \"brew install git\"...\e[0m\n";exit 1; }

## 检查 OCLint 是否存在
lint=$(which oclint) 
[[ -x "$lint" ]] || { printf "\e[1;31mOCLint Not Found, use \"brew tap oclint/formulae && brew install oclint\" to install\e[0m\n"; exit 1; }

## 获取当前分支

branch=$(git rev-parse --abbrev-ref HEAD)
echo "Current Branch: $branch"

## 在本分支修改的文件
# files=$(git diff --name-only dev $(git merge-base dev master) | grep '^[^(Pods/)].*\.m$')

## 在本分支新增的文件(Pods 除外)
files=$(git diff --name-only --diff-filter=A develop $branch | grep '^[^(Pods/)].*\.[mh]$')

commnadFiles=""
echo "\nAnalized Files:\n--------------------------------"
for file in $files; do
    if [[ -f $file ]]; then
        echo $file
        commnadFiles=" $commnadFiles $file"
    fi
done
echo "--------------------------------\n"

[[ -n "$commnadFiles" ]] || { printf "\e[1;36m没有新增文件\e[0m\n"; exit 0; }

## 输出类型，默认 html
type=$1
[[ -n $1 ]] || type='html'
echo "Report Type: $type"

report_file_o="./report_result.$type"
oclint $commnadFiles -report-type $type -R rules -o $report_file_o \
-max-priority-1 100000 \
-max-priority-2 100000 \
-max-priority-3 100000 \
-rc LONG_METHOD=50 \
-rc LONG_LINE=200 \
-rc TOO_MANY_PARAMETERS=8 \
-- -x objective-c -std=gnu99 -fobjc-arc

if [ $? -eq 0 ]; then
    printf "\e[1;36m报告生成成功！\e[0m\n"
else
    printf "\e[1;31m报告生成失败\e[0m\n"
    exit 1
fi
