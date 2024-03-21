DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE user_id_var INT;
    DECLARE total_score FLOAT;
    DECLARE total_weight FLOAT;
    DECLARE avg_weighted_score FLOAT;

    -- Declare cursor for selecting all user IDs
    DECLARE user_cursor CURSOR FOR
        SELECT id FROM users;

    -- Declare continue handler for the cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET user_id_var = NULL;

    -- Open the cursor
    OPEN user_cursor;

    -- Loop through all user IDs
    user_loop: LOOP
        FETCH user_cursor INTO user_id_var;
        IF user_id_var IS NULL THEN
            LEAVE user_loop;
        END IF;

        -- Calculate total score and total weight for the user
        SELECT SUM(c.score * p.weight), SUM(p.weight)
        INTO total_score, total_weight
        FROM corrections c
        INNER JOIN projects p ON c.project_id = p.id
        WHERE c.user_id = user_id_var;

        -- Calculate average weighted score
        IF total_weight > 0 THEN
            SET avg_weighted_score = total_score / total_weight;
        ELSE
            SET avg_weighted_score = 0;
        END IF;

        -- Update the average score for the user
        UPDATE users
        SET average_score = avg_weighted_score
        WHERE id = user_id_var;
    END LOOP;

    -- Close the cursor
    CLOSE user_cursor;
END//

DELIMITER ;
