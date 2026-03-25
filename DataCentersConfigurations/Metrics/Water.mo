within DataCentersConfigurations.Metrics;
model Water
parameter Real RR = 30.84 "Nominal Condenser Mass Flow [kg/s]";

  parameter Real COC = 5 "Cycles of Concentration";
  parameter Real Drift = 0.001 "Drift Loss [fraction of RR, e.g., 0.1% = 0.001]";
  parameter Real Eva_Factor = 0.85 "Evaporation Factor";

  Real Range "Range";
  Real Eva_loss "Evaporation loss [kg/s]";
  Real Drift_loss "Drift loss [kg/s]";
  Real blowdown "Blowdown rate [kg/s]";
  Real Makeup "Total makeup water [kg/s]";

  Modelica.Blocks.Interfaces.RealInput TCWSup
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput TCWRet
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput TWb
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput y annotation (Placement(transformation(
          extent={{90,-10},{110,10}}), iconTransformation(extent={{90,-10},{110,
            10}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=Makeup)
    annotation (Placement(transformation(extent={{34,-10},{54,10}})));
  Modelica.Blocks.Interfaces.RealInput Valve annotation (Placement(
        transformation(extent={{-164,52},{-100,116}}), iconTransformation(
          extent={{-140,60},{-100,100}})));
equation
  // Standard cooling tower approximations
  Range = TCWRet - TCWSup; // Delta T
  Eva_loss = (RR*Range*Eva_Factor)/1000; // Evaporation Loss
  blowdown = Eva_loss/(COC -1); // blowdown
  Drift_loss = RR * Drift; //  Drift Loss
  Makeup = Valve*(Eva_loss + Drift_loss + blowdown)*16.67; // Water Usage in liter
  connect(realExpression.y, y)
    annotation (Line(points={{55,0},{100,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Water;
