within DataCentersConfigurations.Components;
model D2C
  import Buildings;
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare final package Medium = Buildings.Media.Water "Water",
    final m_flow_nominal=mrack_flow_nominal,
    V=v,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    annotation (Placement(transformation(extent={{-52,-24},{-32,-44}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-78,-44},{-58,-24}})));
  Modelica.Blocks.Math.Gain gain(k=1000000)
    annotation (Placement(transformation(extent={{-104,-70},{-84,-50}})));
    parameter Modelica.Units.SI.MassFlowRate mrack_flow_nominal=6
    "Nominal mass flow rate at Racks";
    parameter Real v=3
    "Volume of rack [m3]";
    parameter Real tcduretset = 273.15 + 50 "CDU Return Set Temperature [K]";
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          rotation=0, extent={{-137,-70},{-111,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Buildings.Media.Water)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Buildings.Media.Water)
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Buildings.Media.Water,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos40slash1to8 per,
    addPowerToMedium=false,
    final m_flow_nominal=mrack_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump for condenser water loop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-66,0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(m_flow_nominal=
        mrack_flow_nominal,
                         redeclare package Medium = Buildings.Media.Water)
    "Temperature sensor" annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=0,
        origin={-89,0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(m_flow_nominal=
        mrack_flow_nominal,
                         redeclare package Medium = Buildings.Media.Water)
    "Temperature sensor" annotation (Placement(transformation(
        extent={{-5,-6},{5,6}},
        rotation=0,
        origin={13,0})));
  Buildings.Controls.Continuous.LimPID
                             conFan(
    k=1,
    Ti=60,
    Td=10,
    yMax=1,
    yMin=0.01,
    initType=Modelica.Blocks.Types.Init.InitialState,
    reverseActing=false)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-90,18},{-86,22}})));
  Modelica.Blocks.Sources.Constant const4(k=tcduretset)
    annotation (Placement(transformation(extent={{40,24},{34,30}})));
  Modelica.Blocks.Math.Gain gain1(k=mrack_flow_nominal)
    annotation (Placement(transformation(extent={{-74,18},{-70,22}})));
equation
  connect(vol.heatPort, prescribedHeatFlow.port)
    annotation (Line(points={{-52,-34},{-58,-34}},
                                                 color={191,0,0}));
  connect(gain.y, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-83,-60},{-80,-60},{-80,-34},{-78,-34}},
                                                 color={0,0,127}));
  connect(u, gain.u) annotation (Line(points={{-124,-60},{-106,-60}},
                    color={0,0,127}));
  connect(TRet.port_b, port_b)
    annotation (Line(points={{18,0},{40,0}}, color={0,127,255}));
  connect(const4.y, conFan.u_s)
    annotation (Line(points={{33.7,27},{-102,27},{-102,20},{-90.4,20}},
                                                             color={0,0,127}));
  connect(gain1.u, conFan.y)
    annotation (Line(points={{-74.4,20},{-85.8,20}}, color={0,0,127}));
  connect(TRet.port_a, vol.ports[1]) annotation (Line(points={{8,0},{-40,0},{-40,
          -24},{-43,-24}}, color={0,127,255}));
  connect(conFan.u_m, TRet.T) annotation (Line(points={{-88,17.6},{-88,16},{13,
          16},{13,6.6}},
                     color={0,0,127}));
  connect(port_a, TSup.port_a)
    annotation (Line(points={{-120,0},{-96,0}}, color={0,127,255}));
  connect(TSup.port_b, pum.port_a)
    annotation (Line(points={{-82,0},{-76,0}}, color={0,127,255}));
  connect(pum.port_b, vol.ports[2])
    annotation (Line(points={{-56,0},{-41,0},{-41,-24}}, color={0,127,255}));
  connect(gain1.y, pum.m_flow_in)
    annotation (Line(points={{-69.8,20},{-66,20},{-66,12}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-120,-80},{40,80}})),Icon(
        coordinateSystem(extent={{-120,-80},{40,80}})));
end D2C;
