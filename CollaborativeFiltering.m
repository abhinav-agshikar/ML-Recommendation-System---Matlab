function [gRMSE, gMAE] = CollaborativeFiltering(movie_ids,user_ids,ratings, S)
    overall_rating = 0.0;
    gMAE = 0.0;
    gRMSE = 0.0;
    Norm = 1/527;
    
    for i=1:10
        user_rating = zeros(size(unique(user_ids),1),1);
        user_review_cnt = zeros(size(unique(user_ids),1),1);
        business_rating = zeros(17770,1);
        business_review_cnt = zeros(17770,1);
       
        M = zeros(1000, 17770);

         to_be_skipped_from = int64(((i-1)*size(movie_ids,1))/10);
         to_be_skipped = int64(size(movie_ids,1)/10);
         
         if to_be_skipped_from == 0
             to_be_skipped_from = 1;
         end
         disp('To be skipped:')
         disp(to_be_skipped_from);
         disp(to_be_skipped);
        % pause(5);
         
         training_set_size = int64(0.9*size(movie_ids,1));
         validation_set_size = int64(0.1*size(movie_ids,1));
                 
         
         for j=1:to_be_skipped_from
             user_rating(user_ids(j)) = user_rating(user_ids(j)) + ratings(j);
             business_rating(movie_ids(j)) = business_rating(movie_ids(j)) + ratings(j);
             user_review_cnt(user_ids(j)) = user_review_cnt(user_ids(j)) + 1;
             business_review_cnt(movie_ids(j)) = business_review_cnt(movie_ids(j)) + 1;
             overall_rating = overall_rating+ratings(j);
             M(user_ids(j),movie_ids(j)) = ratings(j);
         end
         
         %disp('final');
         %disp(to_be_skipped_from+to_be_skipped+1);
         %disp(size(movie_ids,1));
         %disp(size(business_rating,1));
         for j=to_be_skipped_from+to_be_skipped+1:size(movie_ids,1)
             user_rating(user_ids(j)) = user_rating(user_ids(j)) + ratings(j);
             business_rating(movie_ids(j)) = business_rating(movie_ids(j)) + ratings(j);
             user_review_cnt(user_ids(j)) = user_review_cnt(user_ids(j)) + 1;
             business_review_cnt(movie_ids(j)) = business_review_cnt(movie_ids(j)) + 1;
             overall_rating = overall_rating+ratings(j);
         end 
         
         for j=1:max(user_ids)
             if user_review_cnt(j) > 0
                 user_rating(j) = double(user_rating(j))/double(user_review_cnt(j));
             end
         end
         
         for j=1:max(movie_ids)
             if business_review_cnt(j) > 0
                 business_rating(j) = double(business_rating(j))/double(business_review_cnt(j));
             end
         end
         overall_rating = double(overall_rating)/double(training_set_size);
         MAE = 0.0;
         RMSE = 0.0;
%          disp('Size:');
%          disp(size(user_ids));
%          disp(size(movie_ids));
         
         for j=to_be_skipped_from:to_be_skipped_from+to_be_skipped
             Predicted = 0;
             for k = 1:10000
                 Predicted = Predicted + S(user_ids(j),user_ids(k))*(M(user_ids(k),movie_ids(j)) - user_rating(user_ids(k)));
             end
             Predicted = Norm*Predicted;
             Predicted = Predicted + user_rating(user_ids(j));
             
             MAE = MAE + abs(Predicted - double(ratings(j)) );
             RMSE = RMSE + (Predicted  - double(ratings(j)) )^2;
         end
%          disp('RMSE');
%          disp(RMSE);
%          disp(size(RMSE));
%          disp(validation_set_size);
%          disp(size(validation_set_size));
         %pause(5);
        % X = MAE/validation_set_size;
        % Y = RMSE/validation_set_size;
          disp(double(MAE)/double(validation_set_size));
         disp(double(RMSE)/double(validation_set_size));
         gMAE = gMAE + double(MAE)/double(validation_set_size);
         gRMSE = gRMSE + sqrt((double(RMSE)/double(validation_set_size)));
         
    end
    gMAE = gMAE/10;
    gRMSE = gRMSE/10;
    
    disp('gMAE');
    disp(gMAE);
    disp('gRMSE');
    disp(gRMSE);
end

% 
% gRMSE =
% 
%     1.1134
% 
% 
% gMAE =
% 
%     0.8845