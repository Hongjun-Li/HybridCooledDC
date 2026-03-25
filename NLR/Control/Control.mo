within NLR.Control;
model Control
  parameter Real TCWRetSet = 273.15 + 3.33 "Condensor Ret. Temp For Freeze Protection [K]";
  parameter Real CW_flownominal = 30 "Nominal Condensor Mass Flow Rate [kg/s]";
  parameter Real CHW_flownominal = 30 "Nominal Chilled Water Mass Flow Rate [kg/s]";
  parameter Real TEnter = 273.15 + 27 "Max Entering Temp. for CDU (FWS) [K]";
  CondensorLoop.Overall CW(TCWRetSet=TCWRetSet, CW_flownominal=CW_flownominal)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Temperature
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),
        iconTransformation(extent={{-74,-14},{-46,12}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Control
    annotation (Placement(transformation(extent={{40,-20},{80,20}}),
        iconTransformation(extent={{46,-14},{74,12}})));
  ChilledWaterLoop.Overall FWS(CHW_flownominal=CHW_flownominal, TEnter=TEnter)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(CW.CWControl, Control) annotation (Line(
      points={{10,39.8333},{10,40},{20,40},{20,0},{60,0}},
      color={255,204,51},
      thickness=0.5));
  connect(Temperature, CW.Temperature) annotation (Line(
      points={{-60,0},{-20,0},{-20,40},{-16,40},{-16,39.8333},{-10,39.8333}},
      color={255,204,51},
      thickness=0.5));
  connect(Temperature, FWS.Temperature) annotation (Line(
      points={{-60,0},{-58,-0.166667},{-10,-0.166667}},
      color={255,204,51},
      thickness=0.5));
  connect(FWS.CHWControl, Control) annotation (Line(
      points={{10,-0.166667},{12,0},{60,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},
            {60,60}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-60,-60},{60,60}})));
end Control;
