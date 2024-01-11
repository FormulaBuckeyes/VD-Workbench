function [] = ShockSpeedHistogram(run, time)
%ShockSpeedHistogram 

SSFL = gradient(run.SuspPosFL, time);
ReboundFL = SSFL(SSFL < 0);
BumpFL = SSFL(SSFL > 0);

SSFR = gradient(run.SuspPosFR, time);
ReboundFR = SSFR < 0;
BumpFR = SSFR > 0;

SSRL = gradient(run.SuspPosRL, time);
ReboundRL = SSRL < 0;
BumpRL = SSRL > 0;

SSRR = gradient(run.SuspPosRR, time);
ReboundRR = SSRR < 0;
BumpRR = SSRR > 0;

tiledlayout("flow")
title("Shock Speed Histograms")
FL = nexttile();
histogram(SSFL, 'Normalization','probability')
title("FL")
subtitle(sprintf("Avg %.1f Hi %.1f Lo %.1f | Lo %.1f Hi %.1f Avg %.1f",...
    mean(ReboundFL),max(ReboundFL),min(ReboundFL),...
    min(BumpFL),max(BumpFL),mean(BumpFL)))
ylabel("Percent of Time")
xlabel("< Rebound | Bump >")

FR = nexttile();
histogram(SSFR, 'Normalization','probability')
title("FR")
subtitle(sprintf("Avg %.1f Hi %.1f Lo %.1f | Lo %.1f Hi %.1f Avg %.1f",...
    mean(ReboundFR),max(ReboundFR),min(ReboundFR),...
    min(BumpFR),max(BumpFR),mean(BumpFR)))
ylabel("Percent of Time")
xlabel("< Rebound | Bump >")

RL = nexttile();
histogram(SSFR, 'Normalization','probability')
title("FR")
subtitle(sprintf("Avg %.1f Hi %.1f Lo %.1f | Lo %.1f Hi %.1f Avg %.1f",...
    mean(ReboundRL),max(ReboundRL),min(ReboundRL),...
    min(BumpRL),max(BumpRL),mean(BumpRL)))
ylabel("Percent of Time")
xlabel("< Rebound | Bump >")

RR = nexttile();
histogram(SSFR, 'Normalization','probability')
title("FR")
subtitle(sprintf("Avg %.1f Hi %.1f Lo %.1f | Lo %.1f Hi %.1f Avg %.1f",...
    mean(ReboundRR),max(ReboundRR),min(ReboundRR),...
    min(BumpRR),max(BumpRR),mean(BumpRR)))
ylabel("Percent of Time")
xlabel("< Rebound | Bump >")

linkaxes([FL FR], 'xy')
linkaxes([RL RR], 'xy')

end