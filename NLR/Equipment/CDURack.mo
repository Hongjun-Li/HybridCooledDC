within NLR.Equipment;
model CDURack
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(show_T=false);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=false,
    final computeFlowResistance2=false,
    from_dp1=false,
    from_dp2=false);


  parameter Real v=3
    "Volume of rack [m3]";
  parameter Real tcduretset = 273.15 + 50 "CDU Return Set Temperature [K]";
  WSE HX(
    redeclare package Medium1 = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    redeclare package Medium2 = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=249*3)
    annotation (Placement(transformation(extent={{-10,8},{10,28}})));
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
    annotation (Placement(transformation(extent={{60,80},{40,100}})));
  Modelica.Blocks.Sources.Constant const4(k=tcduretset)
    annotation (Placement(transformation(extent={{100,80},{80,100}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(m_flow_nominal=
        m2_flow_nominal,    redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction")
    "Temperature sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,-10})));
  Modelica.Blocks.Math.Gain gain1(k=m2_flow_nominal)
    annotation (Placement(transformation(extent={{20,80},{0,100}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Buildings.Media.Antifreeze.PropyleneGlycolWater
        (property_T=293.15, X_a=0.40)
      "Propylene glycol water, 40% mass fraction",
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos40slash1to8 per,
    addPowerToMedium=false,
    final m_flow_nominal=m2_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump for condenser water loop" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-30,-10})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(m_flow_nominal=
        m2_flow_nominal,    redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=293.15, X_a
          =0.40) "Propylene glycol water, 40% mass fraction")
    "Temperature sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-10})));
equation
  connect(port_a1, HX.port_a1) annotation (Line(points={{-100,60},{-16,60},{-16,
          24},{-10,24}}, color={0,127,255},
      thickness=0.5));
  connect(HX.port_b1, port_b1) annotation (Line(points={{10,24},{16,24},{16,60},
          {100,60}}, color={0,127,255},
      thickness=0.5));
  connect(const4.y, conFan.u_s)
    annotation (Line(points={{79,90},{62,90}},  color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRet.T, conFan.u_m)
    annotation (Line(points={{50,1},{50,78}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conFan.y, gain1.u)
    annotation (Line(points={{39,90},{22,90}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gain1.y, pum.m_flow_in)
    annotation (Line(points={{-1,90},{-30,90},{-30,2}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TSup.port_a, port_b2) annotation (Line(points={{-80,-10},{-100,-10},{-100,
          -60}}, color={0,127,255},
      thickness=0.5));
  connect(TSup.port_b, pum.port_b)
    annotation (Line(points={{-60,-10},{-40,-10}}, color={0,127,255},
      thickness=0.5));
  connect(TRet.port_b, port_a2) annotation (Line(points={{60,-10},{100,-10},{
          100,-60}},
                 color={0,127,255},
      thickness=0.5));
  connect(pum.port_a, HX.port_b2) annotation (Line(points={{-20,-10},{-16,-10},
          {-16,12},{-10,12}},
                           color={0,127,255},
      thickness=0.5));
  connect(TRet.port_a, HX.port_a2) annotation (Line(points={{40,-10},{16,-10},{
          16,12},{10,12}},
                      color={0,127,255},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-80,72}},
          color={255,255,255},
          thickness=0.5),
        Rectangle(
          extent={{-72,80},{68,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,80},{38,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-42,80},{-38,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,80},{0,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,-55},{99,-65}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,65},{101,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CDURack;
