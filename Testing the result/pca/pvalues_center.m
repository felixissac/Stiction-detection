function p = pvalues(OP,PV)
    
    X = zeros(size(PV,1),2);
    p = zeros(size(PV));
    for i = 1:size(PV,2)
        X(:,1) = (OP(:,i));
        X(:,2) = (PV(:,i));
        %[X_norm, mu, sigma] = featureNormalize(X);
        X_norm = normalize(X,'center');
        
        TF = isnan(X_norm);

        if TF(1,2) == 1 | TF(1,1) == 1
            X_norm = zeros(size(X_norm));
        end     
        
        [U, S] = pca(X_norm);
        K = 1;
        p(:,i) = projectData(X_norm, U, K); 
        
    end

end

function [U, S] = pca(X)

    [m, n] = size(X);
    U = zeros(n);
    S = zeros(n);

    cov = (1/m)*(X'*X);
    [U, S, V] = svd(cov);

end


function Z = projectData(X, U, K)

    Z = zeros(size(X, 1), K);

    U_reduce = U(:, 1:K); %2x1
    for i=1:size(X,1)
        x = X(i, :); %1x2
        Z(i,:) = x*U_reduce;  %Z is mxK matrix
    end

end

function X_rec = recoverData(Z, U, K)

    X_rec = zeros(size(Z, 1), size(U, 1));

    U_reduce = U(:, 1:K); %2x1
    for i=1:size(Z,1)
        v = Z(i, :);
        X_rec(i,:) = U_reduce*v;
    end

end