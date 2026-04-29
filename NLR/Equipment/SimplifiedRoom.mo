within NLR.Equipment;
model SimplifiedRoom "Simplified data center room"
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model";
  parameter Integer nPorts=0 "Number of parts" annotation (Evaluate=true,
      Dialog(
      connectorSizing=true,
      tab="General",
      group="Ports"));
  parameter Modelica.Units.SI.Length rooLen "Length of the room";
  parameter Modelica.Units.SI.Length rooWid "Width of the room";
  parameter Modelica.Units.SI.Height rooHei "Height of the room";
  parameter Modelica.Units.SI.Power QRoo_flow
    "Heat generation of the computer room";

  Buildings.Fluid.MixingVolumes.MixingVolume rooVol(
    redeclare package Medium = Medium,
    nPorts=nPorts,
    V=rooLen*rooWid*rooHei,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final T_start=293.15,
    final prescribedHeatFlowRate=true) "Volume of air in the room" annotation (Placement(
        transformation(extent={{31,-20},{51,0}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b airPorts[nPorts](
      redeclare each package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(
        extent={{-38,-12},{38,12}},
        rotation=180,
        origin={0,-100}), iconTransformation(
        extent={{-40.5,-13},{40.5,13}},
        rotation=180,
        origin={4.5,-87})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow QSou
    "Heat source of the room"
    annotation (Placement(transformation(extent={{-18,-10},{2,10}})));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TAir
    "Room air temperature"
    annotation (Placement(transformation(extent={{40,26},{60,46}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAir(unit="K", displayUnit="degC")
    "Room air temperature" annotation (Placement(transformation(extent={{100,-10},
            {120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          extent={{-120,-20},{-80,20}}), iconTransformation(extent={{-120,-20},
            {-80,20}})));
equation
  connect(rooVol.ports, airPorts) annotation (Line(
      points={{41,-20},{40,-20},{40,-80},{0,-80},{0,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(QSou.port, rooVol.heatPort) annotation (Line(
      points={{2,0},{22,0},{22,-10},{31,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAir.port, rooVol.heatPort) annotation (Line(points={{40,36},{22,36},
          {22,-10},{31,-10}},color={191,0,0}));
  connect(TAir.T, TRooAir) annotation (Line(points={{61,36},{61,0},{110,0}},
               color={0,0,127}));
  connect(u, QSou.Q_flow)
    annotation (Line(points={{-100,0},{-18,0}}, color={0,0,127}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=1)}),
    Documentation(info="<html>
<p>
This is a simplified room model for a data center. There is no heat exchange between the room and ambient environment through the building envelope since it is negligible compared to the heat released by the servers.
</p></html>", revisions="<html>
<ul>
<li>
July 17, 2015, by Michael Wetter:<br/>
Added <code>prescribedHeatFlowRate=false</code> for both volumes.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/282\">
issue 282</a> of the Annex 60 library.
</li>
<li>
July 21, 2011 by Wangda Zuo:<br/>
Merge to library.
</li>
<li>
December 10, 2010 by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimplifiedRoom;
