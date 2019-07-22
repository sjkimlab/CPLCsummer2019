% One should have Excel output from a microplate reader
rawData = 0;
% copy and paste the Excel output (OD420 from 16 samples, reading 266 time points; hence 266x16) into rawData in Workspace.
% 266 time points are timeseries = [0;2;4;6;8;10;12;14;16;18;20;22;24;26;28;30;32;34;36;38;40;42;44;46;48;50;52;54;56;58;60;62;64;66;68;70;72;74;76;78;80;82;84;86;88;90;92;94;96;98;100;102;104;106;108;110;112;114;116;118;120;122;124;126;128;130;132;134;136;138;140;142;144;146;148;150;152;154;156;158;160;162;164;166;168;170;172;174;176;178;180;182;184;186;188;190;192;194;196;198;200;202;204;206;208;210;212;214;216;218;220;222;224;226;228;230;232;234;236;238;240;245;250;255;260;265;270;275;280;285;290;295;300;305;310;315;320;325;330;335;340;345;350;355;360;365;370;375;380;385;390;395;400;405;410;415;420;425;430;435;440;445;450;455;460;465;470;475;480;485;490;495;500;505;510;515;520;525;530;535;540;545;550;555;560;565;570;575;580;585;590;595;600;605;610;615;620;625;630;635;640;645;650;655;660;665;670;675;680;685;690;695;700;705;710;715;720;725;730;735;740;745;750;755;760;765;770;775;780;785;790;795;800;805;810;815;820;825;830;835;840;845;850;855;860;865;870;875;880;885;890;895;900;905;910;915;920;925;930;935;940;945;950;955;960;965];
mslope = MillerslopeKH(rawData,2);


% % Alternative approach in calculating mslope;
% % rawData, same as above
% od550 = 0;
% % For od550, copy and paste Excel output into od550, 
% % it is OD550 reading in each well for each timepoint when OD420 was
% % measured.
% mslope = MillerslopeWolf(rawData,od550,2);

% for LacZ activity, I used this equation. Calculation was done in Excel.
od600 = 0;
% copy and paste the Excel output (OD600 from 16 samples, reading 5 time points; hence 5x16) into od600 in Workspace.
od600 = mean(od600,1)';
MU = 1000*mslope./od600/0.597;

LacZtime = [0;1;2;4;6;7;8;9;10;11;12;13;14;15;16;17]; %modify as needed
figure, plot(LacZtime, MU);


