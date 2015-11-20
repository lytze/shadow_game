require(shiny)
require(shinysky)
require(knitr)

shinyServer(function(input, output) {
    # Extensions
    source('multiAction.R')
    # Static Values
    idols <- c("GUMI", "一十木音也", "三浦梓", "东条希", "初音", "南小鸟", "四条贵音",
               "园田海未", "天海春香", "如月千早", "小泉花阳", "我那霸响", "星井美希",
               "星空凛", "水瀬伊织", "洛天依", "矢泽妮可", "秋月律子", "绚濑绘里", "菊地真",
               "萩原雪步", "西木野真姬", "巡音", "镜音双子", "音无小鸟", "高坂穗乃果", "高槻弥生")
    mapping <- c(1, 1, 2, 3, 4, 4, 4, 5, 5, 6, 6, 6, 7, 8, 8, 8, 9, 10, 11,
                 11, 11, 12, 13, 14, 14, 14, 15, 16, 17, 17, 17, 18, 19, 19,
                 19, 20, 21, 22, 22, 22, 23, 23, 24, 24, 25, 26, 26, 26, 27)
    filenames <- c("1.jpg", "2.png", "3.jpg", "4.png", "5.png", "6.jpg", "7.jpg", "8.jpg", "9.jpg",
                   "10.png", "11.jpg", "12.jpg", "13.png", "14.png", "15.jpg", "16.jpg", "17.jpg",
                   "18.png", "19.png", "20.jpg", "21.jpg", "22.png", "23.png", "24.png", "25.jpg",
                   "26.png", "27.png", "28.jpg", "29.png", "30.jpg", "31.jpg", "32.jpg", "33.png",
                   "34.jpg", "35.jpg", "36.png", "37.jpg", "38.png", "39.jpg", "40.jpg", "41.jpg",
                   "42.jpg", "43.jpg", "44.jpg", "45.jpg", "46.png", "47.jpg", "48.jpg", "49.jpg")
    play_list <- integer(5)
    marus <- 0
    bazus <- 0
    last <- F
    # Reactive Values
    RV <- reactiveValues(state = 0)
    # Output Functions
    generateStartPage <- function() {
        list(
            div(class = 'start-page-well',
                h3('〜猜剪影〜ガチャ！アイドル'),
                br(),
                helpText(paste0('从给出的动漫偶像角色剪影中找到所指的偶像！',
                                '如果你在 5 次游戏中成功指出 3 次，',
                                '便可以获得一个印章！')),
                helpText('点『开始游戏』来玩吧！'),
                br(),
                actionButton(inputId = 'startGame', label = '开始游戏',
                             styleclass = 'success', size = 'large', block = T)
            )
        )
    }
    generateCongradPage <- function() {
        list(
            div(class = 'congrad-page-well',
                h3('恭喜你！'),
                br(),
                helpText(paste0('你已经成功的找出了 3 名偶像！',
                                '向工作人员索要一个印章吧！')),
                br(),
                actionButton(inputId = 'goToInit', label = '回到起点',
                             styleclass = 'info', size = 'large', block = T)
            )
        )
    }
    generateSorryPage <- function() {
        list(
            div(class = 'sorry-page-well',
                h3('抱歉哦 QWQ'),
                br(),
                helpText(paste0('你已经失败了 3 次以上，',
                                '无法达成所需目标了，',
                                '再次排队来玩这个游戏，或者尝试其他游戏吧！')),
                br(),
                actionButton(inputId = 'goToInit', label = '回到起点',
                             styleclass = 'info', size = 'large', block = T)
            )
        )
    }
    generateGamePageOf <- function() {
        round_num <- isolate(RV$state)
        idol_id <- play_list[round_num]
        idol_name <- idols[idol_id]
        puzzle <- sample(filenames[mapping != idol_id], 20, replace = F)
        bingo <- sample(1:20, 1)
        puzzle[bingo] <- filenames[sample(which(mapping == idol_id), 1)]
        list(
            div(class = 'round-play-page',
                h3(paste0('请找出『', idol_name, '』')),
                setMultiActionMonitor(id = 'playerResponse'),
                lapply(1:length(puzzle), function(i) {
                    sel <- puzzle[i]
                    is_correct <- (i == bingo)
                    tags$img(src = #image_uri(paste0('./img/', sel))
                             paste0('./img/', sel), height = 250,
                             class = 'idol-img multi-action-item',
                             which = is_correct, watch = 'playerResponse')
                }),
                if (round_num == 1) {
                    NULL
                } else {
                    if (last) list(
                        div(class = 'correct-mask',
                            div(class = 'mask-well', 
                                h3('ガチャ！答对了！'),
                                helpText('点击继续'))),
                        tags$script(type = 'text/javascript', 'messageTimeOut()')
                    )
                    else list(
                        div(class = 'wrong-mask',
                            div(class = 'mask-well',
                                h3('抱歉，答错了！'),
                                helpText('点击继续'))),
                        tags$script(type = 'text/javascript', 'messageTimeOut()')
                    )
                }
            )
        )
    }
    # Observers
    observeEvent(RV$state, {
        if (RV$state == 0) {
            output$gamePage <- renderUI(generateStartPage())
        } else if (RV$state == -1) {
            output$gamePage <- renderUI(generateCongradPage())
        } else if (RV$state == -2) {
            output$gamePage <- renderUI(generateSorryPage())
        } else {
            output$gamePage <- renderUI(generateGamePageOf())
        }
    })
    observeEvent(input$startGame, {
        RV$state <- 1
        marus <<- 0
        bazus <<- 0
        play_list <<- sample(1:length(idols), 5, replace = F)
    })
    observeEvent(input$goToInit, {
        RV$state <- 0
    })
    observeEvent(input$playerResponse$cnt, {
        if (input$playerResponse$val) {
            last <<- T
            marus <<- marus + 1
            if (marus == 3) {
                RV$state <- -1
            } else {
                RV$state <- RV$state + 1
            }
        } else {
            last <<- F
            bazus <<- bazus + 1
            if (bazus == 3) {
                RV$state <- -2
            } else {
                RV$state <- RV$state + 1
            }
        }
    })
})