within NLR.Control.CondensorLoop;
model Pump
parameter Real CW_flownominal = 30 "Nominal Condensor Mass Flow Rate [kg/s]";
  Modelica.Blocks.Sources.Constant MassFLow(k=1.1*CW_flownominal)
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus CWPumpControl
    annotation (Placement(transformation(extent={{40,-20},{80,20}}),
        iconTransformation(extent={{46,-12},{76,14}})));
equation
  connect(CWPumpControl.PumpCW, MassFLow.y) annotation (Line(
      points={{60,0},{9,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},
            {60,60}})),                                          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},{60,60}})));
end Pump;
