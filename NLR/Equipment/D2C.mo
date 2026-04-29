within NLR.Equipment;
model D2C
  import Buildings;
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction",
    final m_flow_nominal=mrack_flow_nominal,
    V=v,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));
    parameter Modelica.Units.SI.MassFlowRate mrack_flow_nominal=10
    "Nominal mass flow rate at Racks";
    parameter Real v=3
    "Volume of rack [m3]";
    parameter Real tcduretset = 273.15 + 50 "CDU Return Set Temperature [K]";
  Modelica.Blocks.Interfaces.RealInput u annotation (Placement(transformation(
          rotation=0, extent={{-132,-10},{-113,10}}), iconTransformation(extent
          ={{-131,-9},{-113,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40))
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40))
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos40slash1to8 per,
    addPowerToMedium=false,
    final m_flow_nominal=mrack_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump for condenser water loop" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-66,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(m_flow_nominal=
        mrack_flow_nominal, redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction")
    "Temperature sensor" annotation (Placement(transformation(
        extent={{-7,-6},{7,6}},
        rotation=0,
        origin={-101,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(m_flow_nominal=
        mrack_flow_nominal, redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction")
    "Temperature sensor" annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={0,-60})));
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
    annotation (Placement(transformation(extent={{6,-46},{-6,-34}})));
  Modelica.Blocks.Sources.Constant const4(k=tcduretset)
    annotation (Placement(transformation(extent={{38,-46},{26,-34}})));
  Modelica.Blocks.Math.Gain gain1(k=mrack_flow_nominal)
    annotation (Placement(transformation(extent={{-40,-46},{-52,-34}})));
equation
  connect(vol.heatPort, prescribedHeatFlow.port)
    annotation (Line(points={{-40,0},{-52,0}},   color={191,0,0}));
  connect(TRet.port_b, port_b)
    annotation (Line(points={{6,-60},{22,-60},{22,-80},{-30,-80}},
                                             color={0,127,255}));
  connect(const4.y, conFan.u_s)
    annotation (Line(points={{25.4,-40},{7.2,-40}},          color={0,0,127}));
  connect(gain1.u, conFan.y)
    annotation (Line(points={{-38.8,-40},{-6.6,-40}},color={0,0,127}));
  connect(TRet.port_a, vol.ports[1]) annotation (Line(points={{-6,-60},{-30,-60},
          {-30,-10},{-31,-10}},
                           color={0,127,255}));
  connect(conFan.u_m, TRet.T) annotation (Line(points={{0,-47.2},{0,-53.4}},
                     color={0,0,127}));
  connect(port_a, TSup.port_a)
    annotation (Line(points={{-50,-80},{-120,-80},{-120,-60},{-108,-60}},
                                                color={0,127,255}));
  connect(TSup.port_b, pum.port_a)
    annotation (Line(points={{-94,-60},{-76,-60}},
                                               color={0,127,255}));
  connect(pum.port_b, vol.ports[2])
    annotation (Line(points={{-56,-60},{-29,-60},{-29,-10}},
                                                         color={0,127,255}));
  connect(gain1.y, pum.m_flow_in)
    annotation (Line(points={{-52.6,-40},{-66,-40},{-66,-48}},
                                                            color={0,0,127}));
  connect(u, prescribedHeatFlow.Q_flow)
    annotation (Line(points={{-122.5,0},{-72,0}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(extent={{-120,-80},{40,80}})),Icon(
        coordinateSystem(extent={{-120,-80},{40,80}})));
end D2C;
