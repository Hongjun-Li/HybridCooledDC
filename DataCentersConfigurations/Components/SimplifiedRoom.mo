within DataCentersConfigurations.Components;
model SimplifiedRoom
  import Buildings;
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare final package Medium = Buildings.Media.Air "Moist air",
    final m_flow_nominal=mrack_flow_nominal,
    V=v,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    annotation (Placement(transformation(extent={{-52,-24},{-32,-44}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-78,-44},{-58,-24}})));
  Modelica.Blocks.Math.Gain gain(k=1000000)
    annotation (Placement(transformation(extent={{-104,-70},{-84,-50}})));
    parameter Modelica.Units.SI.MassFlowRate mrack_flow_nominal=155
    "Nominal mass flow rate at Racks";
    parameter Real v=150
    "Volume of rack [m3]";
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          rotation=0, extent={{-137,-70},{-111,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Buildings.Media.Air)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Buildings.Media.Air)
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(m_flow_nominal=
        mrack_flow_nominal, redeclare package Medium = Buildings.Media.Air
      "Moist air")
    "Temperature sensor" annotation (Placement(transformation(
        extent={{7,-6},{-7,6}},
        rotation=0,
        origin={-89,0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(m_flow_nominal=
        mrack_flow_nominal, redeclare package Medium = Buildings.Media.Air
      "Moist air")
    "Temperature sensor" annotation (Placement(transformation(
        extent={{-5,-6},{5,6}},
        rotation=0,
        origin={13,0})));
equation
  connect(vol.heatPort, prescribedHeatFlow.port)
    annotation (Line(points={{-52,-34},{-58,-34}},
                                                 color={191,0,0}));
  connect(gain.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-83,-60},{-80,-60},{-80,-34},{-78,-34}},
                                                 color={0,0,127}));
  connect(u, gain.u) annotation (Line(points={{-124,-60},{-106,-60}},
                    color={0,0,127}));
  connect(TSup.port_a, vol.ports[1])
    annotation (Line(points={{-82,0},{-43,0},{-43,-24}}, color={0,127,255}));
  connect(port_a, TSup.port_b)
    annotation (Line(points={{-120,0},{-96,0}}, color={0,127,255}));
  connect(TRet.port_b, port_b)
    annotation (Line(points={{18,0},{40,0}}, color={0,127,255}));
  connect(TRet.port_a, vol.ports[2]) annotation (Line(points={{8,0},{-44,0},{-44,
          -24},{-41,-24}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(extent={{-120,-80},{40,80}})),Icon(
        coordinateSystem(extent={{-120,-80},{40,80}})));
end SimplifiedRoom;
