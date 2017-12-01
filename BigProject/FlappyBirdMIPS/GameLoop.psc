:GAMESTART
    if TestKeyboardStartPressed
        goto GAMELOOP

    resetParameters()
    paintBackGround()
    paintPipe()
    paintBird()
    goto GAMESTART

:GAMELOOP
    if TestKeyboardMovePressed
        reactToKeyboard()
    
    if TestTimingPeriod
        updateParameters()

    if TestGameOver
        goto GAMEOVER

    paintBackGround()
    paintPipe()
    paintBird()

    goto GAMELOOP


:GAMEOVER
    if TestKeyboardRestartPressed
        goto :GAMELOOP

    paintBackGround()
    paintPipe()
    paintBird()
    paintGGWP()
    goto GAMESTART
