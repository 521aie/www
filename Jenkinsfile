node() {
    wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'XTerm', 'defaultFg': 1, 'defaultBg': 2]) {

        // 名称改这里
        def fileName = null
        
        // 打包结果消息推送改这里
        def accessToken = null
        
        def targets = ["Enterprise", "Release"]

        env.TARGET = targets[0]

        checkout scm
        properties([
         parameters([
            string(
            name: "FILE_NAME", 
            defaultValue: fileName != null ? fileName : env.BRANCH_NAME.replaceAll('\\/','_'),
            description: "项目名称（下载包名组成的一部分，默认是分支名，在Jenkinsfile中自定义）"
            ),
            string(
            name: "REPORTER_ACCESS_TOKEN", 
            defaultValue: accessToken != null ? accessToken : "b307bc890124f2eeae1c072df2b40b74a5c7e615838c2729349d69c972c1ad68",
            description: "打包成功后，推送至钉钉机器人（默认火掌柜iOS），多个TOKEN用封号（;）隔开"
            ),
            choice(
            choices: targets.join("\n"),
            description: '构建目标', 
            name: 'TARGET'
            ),
            booleanParam(
            name: "DEBUG", 
            defaultValue: true,
            description: "添加DEBUG宏"
            ),
         ])
        ])

        stage('Package') {
            echo 'Packaging...'

            env.JOB_NAME=env.FILE_NAME

            try {
                sh './jenkins-pack.sh'

                echo 'Success to package'

                sh './jenkins-pack-reporter.sh SUCCESS || true'
            } catch (e) {

                echo 'Fail to package'

                sh './jenkins-pack-reporter.sh FAILURE || true'

                throw e
            }
        }
    }
}
