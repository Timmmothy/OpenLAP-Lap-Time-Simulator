function [] = SWEEP(PARAM_NAMES, PARAM_VALUES, PARAMS_FILE_EXTENSION)

    if length(PARAM_NAMES) > 1
        for VAL = cell2mat(PARAM_VALUES(1))
            assignin('base', PARAM_NAMES(1), VAL);
            
            SWEEP(PARAM_NAMES(2:end), PARAM_VALUES(2:end), PARAMS_FILE_EXTENSION+"_"+PARAM_NAMES(1)+VAL);
        end
    else
        times = [];
        for VAL = cell2mat(PARAM_VALUES(1))
            assignin('base', PARAM_NAMES(1), VAL);
            assignin('base', "SWEEP_PARAMS_FILE_EXTENSION", PARAMS_FILE_EXTENSION+"_"+PARAM_NAMES(1)+VAL);

            evalin('base', "OpenVEHICLE_SWEEP");
            evalin('base', "OpenLAP_SWEEP");
            
            global CURRENT_LAPTIME
            times = [times CURRENT_LAPTIME];

            global CURRENT_SIM
            global SIMULATIONS
            SIMULATIONS = [SIMULATIONS CURRENT_SIM];
        end

        global LAP_TIMES
        LAP_TIMES = [LAP_TIMES; times];
    end
end