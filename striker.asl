// Agent striker in project krislet_player

/* Initial beliefs and rules */
!join_the_game.

+!join_the_game <- join_team(X); !spwan.
+goal_l <- !spwan.
+goal_r <- !spwan.
+goal_kick_r <- !spwan.
+goal_kick_l <- !spwan.

+!spwan <- .wait(team(X) & (X == left | X == right));
           move(-10, 10);
           !attack.

+!attack : team(X) <- !find_ball;
                       if(X == left) {
                          .wait(kick_off_l | play_on);
                       } elif(X == right) {
                         .wait(kick_off_r | play_on);
                       } else {
                          .print("team not found");
                       }
                       !dash_towards_ball;
                       if(X == left) {
                          !find_goal("r");
                       } elif(X == right) {
                          !find_goal("l");
                       }
                       if(X == left) {
                         !strike_to_goal("r");
                       } elif(X == right) {
                         !strike_to_goal("l");
                       }
                       !attack.

+!find_ball : not(distance("ball", "", X)) <- turn(100); !find_ball.
+!find_ball : direction("ball", "", X) & (X > 30.0 | X < -30.0) <- turn(X); !find_ball.
+!find_ball : true <- .print("done, found ball!").

+!dash_towards_ball
    : (distance("ball", "", X) & X > 1.0) & (direction("ball", "", Y) & (Y >= -2.0 & Y <= 2.0))
        <-  .suspend(find_ball);
            dash(X); !dash_towards_ball.
+!dash_towards_ball : direction("ball", "", X) & (X > 2.0 | X < -2.0) <- turn(X); !dash_towards_ball.
+!dash_towards_ball : true <- .print("done, reached ball!").

+!find_goal(G) : not(distance("goal", G, X)) <- .printf("trying to find goal %s", G); .suspend(dash_towards_ball); turn(100); !find_goal(G).
+!find_goal(G) : direction("goal", G, X) & (X > 10.0 | X < -10.0) <-  .printf("trying to find goal %s", G); turn(X); !find_goal(G).
+!find_goal(G) : true <- .printf("done, found goal %s", G).

+!strike_to_goal(G) : distance("goal", G, X) & direction("goal", G, Y) <- kick(0.5, Y); .printf("done, kicked to goal %s", G).