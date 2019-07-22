function mslope = MillerslopeKH(rawData,method)
%{
-About-
This function calculates slope of OD420 increase in Miller assay.

-Inputs-
rawData:  raw data from microplate reader. First column should be time of
reading and columns from second to end should be OD420 readings in each
well.
method: method to select region for fitting. 1 = manual clicking (different
for each well), 2 = define time region (same for all wells)

-Outputs-
mslope:     slope of line fit for each ONPG OD420 increase

-Example-
mslope = MillerslopeKH(rawdata,2);

-Supplementary-

-Keywords-
LacZ, Miller assay

-Dependencies-
millerWorkflow

-References-
Kuhlman, et al. PNAS (2007) vol. 104 pp.6043-8.
https://www.ncbi.nlm.nih.gov/pubmed/17376875

-Author-
Sangjin Kim, 2019 July 22
%}

X = rawData(:,1:end);
[timeall,wellnum] = size(X);

% Usual timeseries;
timeseries = [0;2;4;6;8;10;12;14;16;18;20;22;24;26;28;30;32;34;36;38;40;42;44;46;48;50;52;54;56;58;60;62;64;66;68;70;72;74;76;78;80;82;84;86;88;90;92;94;96;98;100;102;104;106;108;110;112;114;116;118;120;122;124;126;128;130;132;134;136;138;140;142;144;146;148;150;152;154;156;158;160;162;164;166;168;170;172;174;176;178;180;182;184;186;188;190;192;194;196;198;200;202;204;206;208;210;212;214;216;218;220;222;224;226;228;230;232;234;236;238;240;245;250;255;260;265;270;275;280;285;290;295;300;305;310;315;320;325;330;335;340;345;350;355;360;365;370;375;380;385;390;395;400;405;410;415;420;425;430;435;440;445;450;455;460;465;470;475;480;485;490;495;500;505;510;515;520;525;530;535;540;545;550;555;560;565;570;575;580;585;590;595;600;605;610;615;620;625;630;635;640;645;650;655;660;665;670;675;680;685;690;695;700;705;710;715;720;725;730;735;740;745;750;755;760;765;770;775;780;785;790;795;800;805;810;815;820;825;830;835;840;845;850;855;860;865;870;875;880;885;890;895;900;905;910;915;920;925;930;935;940;945;950;955;960;965];

if method == 1
    for i = 1:wellnum 
        display(i)

        % Do manual clinking to select t1 and t2, such that region between t1
        % and t2 is used for line fit
        figure(1), 
        title(['well = ', num2str(i), 'click t1 and t2 for linear regression']);
        plot(timeseries(1:timeall),X(1:timeall,i));hold on;
        pause;
        clk(1:2,1:2) = ginput(2);
        a1 = find(abs(clk(1,1)-timeseries)==min(abs(clk(1,1)-timeseries)));
        a2 = find(abs(clk(2,1)-timeseries)==min(abs(clk(2,1)-timeseries)));
        plot(clk(1,1),clk(1,2),'or',clk(2,1),clk(2,2),'og');
        fit = polyfit(timeseries(a1:a2),X(a1:a2,i),1);
        mslope(i,1) = fit(1);
        hold off;

        % this figure is to check the fit is good
        figure(2),
        plot(timeseries(1:timeall),X(1:timeall,i));hold on;
        plot(timeseries, timeseries.*fit(1)+fit(2),'g-');
        hold off;
    end;
        
elseif method == 2
    figure; cla;
    cc = jet(wellnum);
    for ii = 1:wellnum
        plot(timeseries(1:timeall),X(1:timeall,ii),'Color',cc(ii,:)); hold on;
    end;
    pause;
    clk(1:2,1:2) = ginput(2);
    a1 = find(abs(clk(1,1)-timeseries)==min(abs(clk(1,1)-timeseries)));
    a2 = find(abs(clk(2,1)-timeseries)==min(abs(clk(2,1)-timeseries)));
    plot(clk(1,1),clk(1,2),'or',clk(2,1),clk(2,2),'og');
    hold off;
    
    for i = 1:wellnum
        fit = polyfit(timeseries(a1:a2),X(a1:a2,i),1);
        mslope(i,1) = fit(1);
    end;
    
else
    display('type in correct method as an input');
    return;
end;

