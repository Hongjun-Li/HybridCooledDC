within NLR.Control;
model Overall
  parameter Real TCWRetSet = 273.15 + 3.33 "Condensor Ret. Temp For Freeze Protection [K]";
  parameter Real CW_flownominal = 30 "Nominal Condensor Mass Flow Rate [kg/s]";
  CondensorLoop.Overall CW(TCWRetSet=TCWRetSet, CW_flownominal=CW_flownominal)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Temperature
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),
        iconTransformation(extent={{-74,-14},{-46,12}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Control
    annotation (Placement(transformation(extent={{40,-20},{80,20}}),
        iconTransformation(extent={{-74,-14},{-46,12}})));
equation
  connect(CW.CWControl, Control) annotation (Line(
      points={{10,39.8333},{20,39.8333},{20,40},{30,40},{30,0},{60,0}},
      color={255,204,51},
      thickness=0.5));
  connect(Temperature, CW.Temperature) annotation (Line(
      points={{-60,0},{-40,0},{-40,39.8333},{-10,39.8333}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},
            {60,60}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-60,-60},{60,60}})));
end Overall;
