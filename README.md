# 老火掌柜iOS客户端

需要[Cocoapods][Cocoapods]

```bash
pod install
```

用 `RestApp.xcworkspece` 打开

[Cocoapods]: https://cocoapods.org/


# Code Review

1. 目前只对当前分支新增的文件进行 code review

## 本地 CodeReview

### 环境配置

1. 进入 Terminal，输入 `xcode-select --install`
2. 安装 OCLint: `brew tap oclint/formulae && brew install oclint`

### Code Review

1. 生成报告 `./review.sh`
2. 查看报告 `open report_result.html`


## Jenkins Code Review

1. 新建 Jenkins 项目时从 `iOS-OCLint` 项目拷贝配置即可
2. 构建完成后可以查看报告，比本地生成的 html 更详细一点