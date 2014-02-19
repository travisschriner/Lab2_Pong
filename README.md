Lab2_Pong
=========
This lab will implement a single player version of Air Force Pong. The lab requirements will be as follows:


1. Background image of the "AF" logo
2. User-controllable paddle position on the left side of the screen
3. "Ball" that moves smoothly across the screen
  1. Bounces when it hits the top, right, or bottom walls.
  2. The ball is hidden when it is moving across the logo letters.
  3. When the game is over (i.e., the ball hits the left wall), the ball freezes in position.
4. The game can be restarted by pressing the "reset" button.


Prelab
-------
1) STD for my ball movement in pong_control module
![controller STD] (Pong_controller_STD.png)


2) bounds checking
I will implement bounds checking using a simple if else statement. I will update my ball every time the frame is complete. I will start out by moving the ball 5 pixel per frame. If that is far too fast, I will create a counter so I can slow the ball down. If it is too slow, I will increase the number of pixels the ball moves by. Whenever I update my frame, I will check bounds. I will see if the center of my ball is less than the radius away from the edge. If it is, I will change the update by value for the next frame. This will be done by simply inverting the value of the global var. If I hit the top wall, I will invert the y_dir. If I hit the right wall, I will invert the x_dir. If I hit the left wall, I will set the x_dir and y_dir to zero. 
```vhdl
  process(v_completed)
  begin
    if(ball_y < 5 or ball_y > 475) then
      y_const = -y_const;
    elsif(ball_x > 635) then
      x_const = -x_const;
    elsif(ball_x <5) then
      x_const = 0;
      y_const = 0;
    end if;
  end process;
```

3) paddle update
```vhdl
process(up, down)
begin
  if(up = '1') then
    paddle_y += paddle_dist;
  elsif(down = '1') then
    paddle_y -= paddle_dist;
  elsif (paddle_y < 3 ) then
    paddle_y <= (others => '0');
  elsif(paddle_y > 637) then
    paddle_y <= 640;
  end if;
end process;
```


Discussion
-----------

In order to implement this lab, I had to throw out my state machine and use a different one. My above state machine was constantly glitching and had a hard time dealing with the frame rate. Once my state machine was fixed, my design worked good. Creating Pong on a MCU would be much easier and probably only require about 57 lines of code. I thought I would have to fix my V pulse because it is high for an entire line instead of a single clock cycle. I worked around this by using a rising_edge construct. That saved me the hastle of dealing with my V_sync_gen code. 

Conclusion
-----------
If you do this on an MCU, it is much simpler. The state machines are hard to deal with because they make everything so convoluted. My ball takes about 7 seconds to come on screen and I have no idea why. Once it is on screen, everything works fine. I now have a single player Pong game I can indulge myself on if I decide to buy the $600 FPGA down the road. I might because I enjoy pong, but then again I might just program it on my computer using JAVA so I can play it without having to plug 3 wires in and rewiring my TV every time I want to play. 


