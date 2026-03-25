within NLR.Control.CondensorLoop;
model Overall
  parameter Real TCWRetSet = 273.15 + 3.33 "Condensor Ret. Temp For Freeze Protection [K]";
  parameter Real CW_flownominal = 30 "Nominal Condensor Mass Flow Rate [kg/s]";
  CoolingTower coolingTower(TCWRetSet=TCWRetSet)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  CondenserPump condenserPump(CW_flownominal=CW_flownominal)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Temperature
    annotation (Placement(transformation(extent={{-80,-22},{-40,18}}),
        iconTransformation(extent={{-74,-14},{-46,12}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus CWControl
    annotation (Placement(transformation(extent={{40,-22},{80,18}}),
        iconTransformation(extent={{46,-14},{74,12}})));
  Modelica.Blocks.Sources.RealExpression TCWWet(y=min(23.89 + 273.15, max(
        273.15 + 12.78, weaBus.TWetBul + 3)))
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-40,30},{-24,46}})));
equation
  connect(Temperature, coolingTower.Temperature) annotation (Line(
      points={{-60,-2},{-60,0},{-20,0},{-20,29.8333},{-10,29.8333}},
      color={255,204,51},
      thickness=0.5));
  connect(coolingTower.CTControl, CWControl) annotation (Line(
      points={{10,29.8333},{10,30},{20,30},{20,0},{60,0},{60,-2}},
      color={255,204,51},
      thickness=0.5));
  connect(coolingTower.CTControl, condenserPump.CWPumpControl) annotation (Line(
      points={{10,29.8333},{20,29.8333},{20,-30},{10,-30},{10,-29.8333},{
          10.1667,-29.8333}},
      color={255,204,51},
      thickness=0.5));
  connect(TCWWet.y, coolingTower.TCWSupSet) annotation (Line(points={{-23.2,38},
          {-23.2,38.3333},{-10,38.3333}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},
            {60,60}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-60,-60},{60,60}})));
end Overall;
