% I created this file during NORSE 2021 to help find the lag between files
% in individual sensors in a deployment. Once the lag as found for each
% insturments, Dylan's code was run again with this lag included

% Looking bow_chain data
clearvars
clc

% old Cruise path
% addpath ../Bow_chain/mfiles/BowChain/Code/
% load ../data_mine/underway_AR6002.mat
% %%
% Run Dylan's code
bT_chain=BowChain_master('NORSE', 'Armstrong', 'deployment_5');

% If this was the first time ever running "BowChain_master" I would first
% see each concerto data, and make sure data is correct and it exist. Maybe
% we should have table were we collecte the information for each deployment

first_run = 0; % change this to 1 if is the first run

%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~ FIRST LOOK

if first_run
    
    % Checking latitud
    figure
    num_sens = length(b_chain.pos);
    ji = 1;
    for ii = 1: num_sens
        
        % Finding the individual concerto sensors
        if strcmp(b_chain.info.config.sensors(ii).sensor_type, 'RBR Concerto')
            concertos(ji) = ii;
            ji = ji+1;
        end
        
    end
    
    %% making a structure with all solo and conerto data
    % We should change this, as in 2022 the where duets as well and solos
    % with similar SN than concerto
    
    con_pos = dir('../../../processed/deployment_7/06*');
    
    for ii =1 :length(con_pos)
        conc{ii} = load(['../../../processed/deployment_7/',con_pos(ii).name]);
    end
    
    solo_pos = dir('../../../processed/deployment_7/20*');
    for ii =1 :length(solo_pos)
        solo{ii} = load(['../../../processed/deployment_7/',solo_pos(ii).name]);
    end

    %%
    figure
    plot((conc{1}.dn-datenum(2021, 10,01,0, 0,0))*24, conc{1}.p, 'k.'); hold on
    plot(((conc{2}.dn-datenum(2021, 10,01,0, 0,0)))*24, conc{2}.t, 'b.'); hold on
    plot(((conc{3}.dn-datenum(2021, 10,01,0, 0,0)))*24, conc{3}.p, 'g.'); hold on
    plot((conc{4}.dn-datenum(2021, 10,01,0, 0,0))*24, conc{4}.p, 'r.'); hold on
    %     ylabel('Pressure, 'interpreter','latex')
    
    %%
    
    % For section 6 correctiong
    figure
    plot(((conc{2}.dn-datenum(2021, 09,30,0, 0,0)))*24, '.');
    
    nl = length(conc{2}.dn);
    
    % Quick and dirty correction of the time to see if it was just a time
    % change. 
    vi = [0:nl-1]*1.9293e-6;
    
    conc{2}.dn_old = conc{2}.dn;
    conc{2}.dn = vi+conc{2}.dn(1);
 
    % In Sunrise 2021, dylans code did not "rear" the name of the channels
    % as Fucents code does, so for one concerto the "channel" number for pressure was
    % switch with temperature. so thats why in conc = 2, instead of
    % plotting "p" I ploted "t"
     figure
    plot((conc{1}.dn-datenum(2021, 09,30,0, 0,0))*24, conc{1}.p, 'k.'); hold on
    plot(((conc{2}.dn-datenum(2021, 09,30,0, 0,0)))*24, conc{2}.t, 'b.'); hold on
    plot(((conc{3}.dn-datenum(2021, 09,30,0, 0,0)))*24, conc{3}.p, 'g.'); hold on
    plot((conc{4}.dn-datenum(2021, 09,30,0, 0,0))*24, conc{4}.p, 'r.'); hold on
    %     ylabel('Pressure, 'interpreter','latex')
    
    
%     conc{2}.dn_contr = [conc{2}.dn(1):1.9293e-06:
    
    %% Temperture
    figure
    plot((conc{1}.dn-datenum(2021, 10,01,0, 0,0))*24, conc{1}.t, '.k'); hold on
    plot(((conc{2}.dn-datenum(2021,10,01,0, 0,0)))*24, conc{2}.p, '.b'); hold on
    plot(((conc{3}.dn-datenum(2021, 10,01,0, 0,0)))*24, conc{3}.t, '.g'); hold on
    plot((conc{4}.dn-datenum(2021, 10,01,0, 0,0))*24, conc{4}.t, 'r.'); hold on
    
    %% Salinity
    figure
    plot((conc{1}.dn-datenum(2021, 09,16,0, 0,0))*24, conc{1}.s, 'k.'); hold on
    plot((conc{2}.dn-datenum(2021, 09,16,0, 0,0))*24, conc{2}.s, 'b.'); hold on
    plot(((conc{3}.dn-datenum(2021, 09,16,0, 0,0)))*24, conc{3}.s, 'g.'); hold on
    plot((conc{4}.dn-datenum(2021, 09,16,0, 0,0))*24, conc{4}.s, 'r.'); hold on
    %% THE OFFSET!! ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    %% We are using a cross-correlation to find the best offset possibl for
    % instruments
    % choosing the interval 2 mins before and after the deployment to  make
    % it faster. this should be done in the "plunge" time
    % deployment 7
    interv1 = [datenum(2021, 10 ,1, 15, 19, 00), datenum(2021, 10, 1, 15, 24, 30)];
        
    % deployment 6
%     interv1 = [datenum(2021, 09 ,30, 15, 24, 00), datenum(2021, 09, 30, 15, 26, 30)];
        
    % deployment 5
%     interv1 = [datenum(2021, 09 ,26, 9, 13, 00), datenum(2021, 09, 26, 9, 20, 00)];
    
    % deployment 4
    %     interv1 = [datenum(2021, 09 ,16, 21, 03, 00), datenum(2021, 09, 16, 21, 7, 00)];
    % deployment 3
    %     interv1 = [datenum(2021, 09 ,15, 12, 00, 00), datenum(2021, 09, 15, 12, 16, 00)];
    % deployment 2
    %     interv1 = [datenum(2021, 09 ,10, 10, 12, 00), datenum(2021, 09, 10, 11, 06, 00)];

    %% Creating the intervels
    
    % I chose concerto 4 as our control.
    ab = conc{4}.dn >= interv1(1) & conc{4}.dn <= interv1(2);
    %%
    %  range_cc=[datenum(2021, 09 ,16, 21, 03, 00), datenum(2021, 09, 17, 03, 0, 0)];
    % [offset_sr, mean_offset] = bow_chain_crosscorr(solo{3}.t, conc{4}.t, solo{3}.dn, conc{4}.dn, range_cc, 20)
    
    %%
    figure
        % Finding the offset for each concerto
        for ii =1 :length(con_pos)
            % Finding the ofssets for concertos
            dt_concerto =nanmean(gradient(conc{4}.dn)); %1.9294e-06; %(6 hz) in days
            cd = conc{ii}.dn >= interv1(1) & conc{ii}.dn <= interv1(2);
            if ii ==2
%                 conc{ii}.t_temp = interp1(conc{ii}.dn(cd), conc{ii}.p(cd), conc{4}.dn(ab));
%                 [lags,rhoyy, rhocrit, Ryy, N]= crosscorr_NAN42(conc{4}.t(ab),conc{ii}.t_temp,1000);
%                  plot(lags, rhoyy), pause(3);
    
    
            else
                conc{ii}.t_temp = interp1(conc{ii}.dn(cd), conc{ii}.t(cd), conc{4}.dn(ab));
                [lags,rhoyy, rhocrit, Ryy, N]= crosscorr_NAN42(conc{4}.t(ab),conc{ii}.t_temp,500);
                  plot(lags, rhoyy), pause(3);
    
            end
            ind_m = find(max(rhoyy)==rhoyy);
            lags(ind_m)*dt_concerto;
            conc{ii}.offset = lags(ind_m)*dt_concerto;
        end
    %% For deployment 5
%     conc{3}.offset =-.602;
%     conc{1}.offset =0;
%     conc{2}.offset =0;
%     conc{4}.offset =0;
    
    %% For deployment 6
    
%     conc{1}.offset =0;
    conc{2}.offset =.0066;
%      conc{2}.offset =0;
%     conc{3}.offset =0;
%     conc{4}.offset =0;
    
    
    %%
%     figure
    % Finding the offset for each solo
    for ii =1 :length(solo_pos)
        % Finding the ofssets for concertos
        %         dt_solo =nanmean(gradient(solo{ii}.dn)) %1.9294e-06; %(6 hz) in days
        cd = solo{ii}.dn >= interv1(1) & solo{ii}.dn <= interv1(2);

        solo{ii}.t_temp = interp1(solo{ii}.dn(cd), solo{ii}.t(cd), conc{4}.dn(ab));
        [lags,rhoyy, rhocrit, Ryy, N]= crosscorr_NAN42(conc{4}.t(ab),solo{ii}.t_temp,400);
%                    plot(lags, rhoyy), pause(2); close;
        ind_m = find(max(rhoyy)==rhoyy);
        solo{ii}.offset = lags(ind_m)*dt_concerto;
        
%         solo{ii}.offset = 0;
%         if ii == 2
%             solo{ii}.offset = -.00009;
%         end
    end
    %
    
    %%
    figure
    for ii = 1:length(solo_pos)
        plot(((solo{ii}.dn + solo{ii}.offset)-datenum(2021, 09,30,0,0,0))*24, solo{ii}.t) ; hold on
    end
    % xlim([12 13])
%     plot(((solo{2}.dn)-datenum(2021, 09,26,0,0,0))*24, solo{2}.t, 'r', 'linewidth', 2) ; hold on
%     xlim([   (interv1(1)-datenum(2021, 09,26,0,0,0))*24, (interv1(end)-datenum(2021, 09,26,0,0,0))*24])
    %%
%     figure
    for ii = 1:4
        plot(((conc{ii}.dn + conc{ii}.offset)-datenum(2021, 09,30,0,0,0))*24, conc{ii}.t, '.') ; hold on
    end
    % xlim([12 13])
    %%
     plot(((conc{2}.dn+ conc{2}.offset)-datenum(2021, 09,30,0,0,0))*24, conc{2}.p, 'r.') ; hold on
    %%
      save offsets_deployment_7 solo  conc
    
% This was then add in Dylans code, before it does the interpolations

