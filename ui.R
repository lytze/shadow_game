require(shiny)
require(knitr)
filenames <- c("1.jpg", "2.png", "3.jpg", "4.png", "5.png", "6.jpg", "7.jpg", "8.jpg", "9.jpg",
               "10.png", "11.jpg", "12.jpg", "13.png", "14.png", "15.jpg", "16.jpg", "17.jpg",
               "18.png", "19.png", "20.jpg", "21.jpg", "22.png", "23.png", "24.png", "25.jpg",
               "26.png", "27.png", "28.jpg", "29.png", "30.jpg", "31.jpg", "32.jpg", "33.png",
               "34.jpg", "35.jpg", "36.png", "37.jpg", "38.png", "39.jpg", "40.jpg", "41.jpg",
               "42.jpg", "43.jpg", "44.jpg", "45.jpg", "46.png", "47.jpg", "48.jpg", "49.jpg")
# Session Stored Images
hidden_img <- lapply(1:length(filenames), function(i)
    tags$img(src = image_uri(paste0('www/img/', filenames[i])),
             class = 'hidden-stored-img', 
             id = paste0('src_', gsub('\\.', '_', filenames[i]))))

shinyUI(fluidPage(
    tags$head(
        tags$script(type = "text/javascript", src = "multiActionInputBinding.js"),
        tags$script(type = "text/javascript", src = "custom.js"),
        tags$link(rel = "stylesheet", type="text/css", href="custom.css"),
        tags$title('〜猜剪影〜ガチャ！アイドル')
    ),
    uiOutput('gamePage', class = 'game-page'),
    div(class = 'session-store', hidden_img)
))