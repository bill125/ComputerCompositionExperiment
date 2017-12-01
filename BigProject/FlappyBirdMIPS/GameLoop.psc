:GAMELOOP
    if TestKeyBoardPressed
        reactToKeyboard()
    
    if TestTimingPeriod
        updateParameters()

    paintBackGround()
    paintPipe()
    paintBird()

    goto GAMELOOP