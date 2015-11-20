require(shiny)

shinyUI(fluidPage(
    tags$head(
        tags$script(type = "text/javascript", src = "multiActionInputBinding.js"),
        tags$script(type = "text/javascript", src = "custom.js"),
        tags$link(rel = "stylesheet", type="text/css", href="custom.css"),
        tags$title('〜猜剪影〜ガチャ！アイドル')
    ),
    uiOutput('gamePage', class = 'game-page')
))