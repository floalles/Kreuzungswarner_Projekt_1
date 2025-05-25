%% Funktion zum Erstellen der Simulink Parameter

% Diese Hilfsfunktion erstellt die Simulink Parameter mit dem übergebenen
% Wert. Sie werden dann mit dem Name aus der assignin Funktion in den
% entsprechenden Speicherort geschrieben.

function Parameter = makeParam(val)
    Parameter = Simulink.Parameter;
    Parameter.Value = val;
    Parameter.CoderInfo.StorageClass = 'ExportedGlobal';
end