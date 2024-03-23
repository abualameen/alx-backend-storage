-- Create Procedure to Compute Average Score for User
DELIMITER $$

CREATE PROCEDURE ComputeAverageScoreForUser(IN user_id INT)
BEGIN
    DECLARE total_score FLOAT;
    DECLARE score_count INT;
    DECLARE avg_score FLOAT;

    -- Calculate total score for the user
    SELECT SUM(score) INTO total_score FROM corrections WHERE user_id = user_id;

    -- Calculate count of scores for the user
    SELECT COUNT(score) INTO score_count FROM corrections WHERE user_id = user_id;

    -- Calculate average score
    IF score_count > 0 THEN
        SET avg_score = total_score / score_count;
    ELSE
        SET avg_score = 0;
    END IF;

    -- Update average score in users table
    UPDATE users SET average_score = avg_score WHERE id = user_id;
    
END$$

DELIMITER ;
