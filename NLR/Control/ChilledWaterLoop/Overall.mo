within NLR.Control.ChilledWaterLoop;
model Overall
  parameter Real CHW_flownominal = 30 "Nominal Chilled Water Mass Flow Rate [kg/s]";
  parameter Real TEnter = 273.15 + 27 "Max Entering Temp. for CDU (FWS) [K]";
  Pump pump(CHW_flownominal=CHW_flownominal)
            annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  MixingValve Valve(TEnter=TEnter)
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Temperature
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),
        iconTransformation(extent={{-74,-14},{-46,12}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus CHWControl
    annotation (Placement(transformation(extent={{40,-20},{80,20}}),
        iconTransformation(extent={{46,-14},{74,12}})));
equation
  connect(Temperature, Valve.Temperature) annotation (Line(
      points={{-60,0},{-20,0},{-20,-30.1667},{-10,-30.1667}},
      color={255,204,51},
      thickness=0.5));
  connect(Valve.ValveControl, CHWControl) annotation (Line(
      points={{10,-30.1667},{20,-30.1667},{20,0},{60,0}},
      color={217,67,180},
      thickness=0.5));
  connect(Valve.ValveControl, pump.CHWPumpControl) annotation (Line(
      points={{10,-30.1667},{20,-30.1667},{20,30.1667},{10.1667,30.1667}},
      color={217,67,180},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},
            {60,60}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-60,-60},{60,60}})));
end Overall;
