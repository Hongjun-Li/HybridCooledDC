within NLR.Control.ChilledWaterLoop;
model MixingValve
  parameter Real TEnter = 273.15 + 27 "Max Entering Temp. for CDU (FWS) [K]";
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus Temperature
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}}),
        iconTransformation(extent={{-74,-14},{-46,12}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus ValveControl
    annotation (Placement(transformation(extent={{40,-20},{80,20}}),
        iconTransformation(extent={{46,-14},{74,12}})));
  Buildings.Controls.Continuous.LimPID
                             conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-8,12},{8,28}})));
  Modelica.Blocks.Sources.Constant EntrySet(k=TEnter)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
equation
  connect(Temperature.TCDUEnt, conFan.u_m) annotation (Line(
      points={{-60,0},{0,0},{0,10.4}},
      color={255,204,51},
      thickness=0.5));
  connect(conFan.y, ValveControl.ValveMix) annotation (Line(
      points={{8.8,20},{20,20},{20,0},{60,0}},
      color={217,67,180},
      thickness=0.5));
  connect(EntrySet.y, conFan.u_s)
    annotation (Line(points={{-19,20},{-9.6,20}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},
            {60,60}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-60,-60},{60,60}})));
end MixingValve;
