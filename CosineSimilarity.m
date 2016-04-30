function [S] = CosineSimilarity(movie_ids,user_ids,ratings)
     S = zeros(1000, 1000);
     M = zeros(1000, 17770);
     
     n = size(movie_ids,1);
     
     for j=1:n
             M(user_ids(j),movie_ids(j)) = ratings(j);
     end
     
     for j=1:1000
         
         for k=j+1:1000
             A = M(j,:);
             B = M(k,:);
             S(j,k) = dot(A,B)/(sqrt(double(sum(A.*A)))*sqrt(double(sum(B.*B))));
         end
         if mod(j,10) == 0
            disp('Done');
            disp(j);
         end
     end
     
     for i=2:1000
        for j=1:i-1
            S(i,j) = S(j,i);
        end
    end
end

