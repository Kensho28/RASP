%n = 3 * 3 * 3 * 8; % Number of states
G = generateRASPDAG();
G2 = generateRASPDAG2();

%figure; plot(digraph(G)); hold on; plot(digraph(G2));

m1=sum(G,1);
m2=sum(G,2);
n=size(G,1);
ind1=(m1==0);
ind2=(m2==0);
n1=sum(ind1==1);
n2=sum(ind2==1);
r1=n-n1;
r2=n-n2;

Gp1=G(~ind1,~ind1);
Gp2=G(~ind2,~ind2);

m12=sum(G2,1);
m22=sum(G2,2);
%n22=size(G2,1);
ind12=(m12==0);
ind22=(m22==0);
%n12=sum(ind12==1);
%n22=sum(ind22==1);
%n2=size(G2,2);
%r12=n2-n12;
%r22=n2-n22;

Gp12=G2(~ind12,~ind12);
Gp22=G2(~ind22,~ind22);


figure;  plot(digraph(Gp2));

% Initial distributions
rhoopt = ones(r2, 1)/r2;
%rhoopt=mpower(Gp2',50)*ones(r2, 1)/r2;
%rhoopt2 = ones(r22, 1)/r22;

%rhoopt(ind)=0;
%rhoopt=rhoopt/sum(rhoopt);
rhop = rand(r2, 1); 
rhop = rhop / sum(rhop);




%rhop2 = rand(r22, 1); 
%rhop2 = rhop2 / sum(rhop2);

NT = 4;
MC = [];
MC2 = [];

for t = 0:0.1:0.9
    rhop0 = t * rhop + (1 - t) * rhoopt;
    MC0 = [];
    q0 = rhoopt;
    rhot = rhop0;
    
    MC02 = [];
    rhop20 = t * rhop + (1 - t) * rhoopt;
%    q02 = rhoopt2;
    rhot2 = rhop20;    
    
    for m = 1:NT
        % First map
        Grhot = Gp2'  * rhot;
        Gq0 = Gp2' * q0;
        % Second map
%        Grhot2 = Gp22'  * rhot2;
%        Gq02 = Gp22' * q02;
        MC0 = [MC0;   KL(rhot, q0)-KL(Grhot, Gq0)];
%        MC02 = [MC02;   KL(rhot2, q02)-KL(Grhot2, Gq02)];
        rhot = Grhot;
    end
    MC = [MC; cumsum(MC0')];
    MC2 = [MC2; cumsum(MC02')];
end

figure; plot(MC','LineWidth',2); %hold on; plot(MC2','r');

function kl_divergence = KL(P, Q)
    % Check if input vectors have the same length
    if length(P) ~= length(Q)
        error('Input vectors must have the same length.');
    end
    
    % Ensure that probabilities sum up to 1
    P = P / sum(P);
    Q = Q / sum(Q);
    
    % Replace zeros with a small non-zero value
    epsilon = 1e-10; % or any other small positive value
    P(P == 0) = epsilon;
    Q(Q == 0) = epsilon;
    
    % Compute KL divergence
    kl_divergence = sum(P .* log(P ./ Q), 'omitnan');
end
