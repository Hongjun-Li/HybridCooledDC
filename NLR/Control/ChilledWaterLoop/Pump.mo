within NLR.Control.ChilledWaterLoop;
model Pump
  parameter Real CHW_flownominal = 30 "Nominal Chilled Water Mass Flow Rate [kg/s]";
  Modelica.Blocks.Sources.Constant MassFLow(k=1.1*CHW_flownominal)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Examples.BusUsage_Utilities.Interfaces.ControlBus CHWPumpControl
    annotation (Placement(transformation(extent={{44,-20},{84,20}}),
        iconTransformation(extent={{46,-12},{76,14}})));
equation
  connect(CHWPumpControl.PumpCW, MassFLow.y) annotation (Line(
      points={{64,0},{13,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-60,-60},
            {60,60}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-60,-60},{60,60}})));
end Pump;
