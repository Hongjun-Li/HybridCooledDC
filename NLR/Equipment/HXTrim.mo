within NLR.Equipment;
model HXTrim
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(show_T=false);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=false,
    final computeFlowResistance2=false,
    from_dp1=false,
    from_dp2=false);


  WSE HX(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=249*3)
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Fluid.Chillers.ElectricEIR chi(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=249*3,
    dp1_nominal=6000,
    per=Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_Carrier_23XL_1196kW_6_39COP_Valve(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-60,0},{-40,21}})));
  Buildings.Fluid.FixedResistances.Junction
                                  spl1(
    redeclare package Medium = Medium1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={m1_flow_nominal,-m1_flow_nominal,-m1_flow_nominal},
    dp_nominal={0,0,0}) "Splitter"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Fluid.FixedResistances.Junction
                                  jun1(
    redeclare package Medium = Medium1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={m1_flow_nominal,-m1_flow_nominal,m1_flow_nominal},
    dp_nominal={0,0,0}) "Junction"
    annotation (Placement(transformation(extent={{62,50},{82,70}})));
  Buildings.Fluid.FixedResistances.Junction
                                  jun2(
    redeclare package Medium = Medium2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal={m2_flow_nominal,-m2_flow_nominal,m2_flow_nominal},
    dp_nominal={0,0,0}) "Junction"
    annotation (Placement(transformation(extent={{-60,-50},{-80,-70}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear Val1(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    dpValve_nominal=6000,
    y_start=1,
    use_strokeTime=false) "Bypass valve: closed when free cooling mode is deactivated;
    open when free cooling is activated" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-70,-24})));
  Modelica.Blocks.Interfaces.RealInput TSet(
    final unit="K",
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Set point for leaving water temperature"
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}}),
        iconTransformation(extent={{-132,92},{-100,124}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear Val2(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    dpValve_nominal=6000,
    y_start=1,
    use_strokeTime=false) "Bypass valve: closed when free cooling mode is deactivated;
    open when free cooling is activated" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,40})));
  Modelica.Blocks.Interfaces.RealOutput powChi(each final quantity="Power",
      each final unit="W") "Electric power consumed by chiller compressor"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Math.BooleanToReal booToRea(each final realTrue=1, each final
            realFalse=0) "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear valLin(
    redeclare package Medium = Medium2,
    l={0.05,0.05},
    m_flow_nominal=m2_flow_nominal,
    use_strokeTime=false,
    dpValve_nominal=6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Valve model, linear opening characteristics"
    annotation (Placement(transformation(extent={{-12,-6},{8,14}})));
  Modelica.Blocks.Math.BooleanToReal booToRea1(each final realTrue=0.5, each final
            realFalse=0) "Boolean to real (if true then 1 else 0)"
    annotation (Placement(transformation(extent={{20,68},{40,88}})));
equation
  connect(port_a1, spl1.port_1)
    annotation (Line(points={{-100,60},{-80,60}}, color={0,127,255}));
  connect(spl1.port_2, HX.port_a1) annotation (Line(
      points={{-60,60},{-20,60},{-20,16},{40,16}},
      color={28,108,200},
      thickness=0.5));
  connect(HX.port_b1, jun1.port_3) annotation (Line(
      points={{60,16},{72,16},{72,50}},
      color={28,108,200},
      thickness=0.5));
  connect(jun1.port_2, port_b1)
    annotation (Line(points={{82,60},{100,60}}, color={0,127,255}));
  connect(port_b2, jun2.port_2)
    annotation (Line(points={{-100,-60},{-80,-60}}, color={0,127,255}));
  connect(HX.port_a2, port_a2) annotation (Line(
      points={{60,4},{72,4},{72,-60},{100,-60}},
      color={28,108,200},
      thickness=0.5));
  connect(on, chi.on) annotation (Line(points={{-120,30},{-84,30},{-84,13.65},{-62,
          13.65}}, color={255,0,255}));
  connect(spl1.port_3, chi.port_a1) annotation (Line(
      points={{-70,50},{-70,18},{-60,18},{-60,16.8}},
      color={217,67,180},
      thickness=0.5));
  connect(TSet, chi.TSet) annotation (Line(
      points={{-120,-10},{-80,-10},{-80,7.35},{-62,7.35}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chi.port_b1, Val2.port_a) annotation (Line(
      points={{-40,16.8},{-28,16.8},{-28,40},{-10,40}},
      color={217,67,180},
      thickness=0.5));
  connect(Val2.port_b, jun1.port_1) annotation (Line(
      points={{10,40},{20,40},{20,60},{62,60}},
      color={217,67,180},
      thickness=0.5));
  connect(jun2.port_3, Val1.port_a) annotation (Line(
      points={{-70,-50},{-70,-34}},
      color={217,67,180},
      thickness=0.5));
  connect(Val1.port_b, chi.port_b2) annotation (Line(
      points={{-70,-14},{-70,4},{-60,4},{-60,4.2}},
      color={217,67,180},
      thickness=0.5));
  connect(chi.P, powChi) annotation (Line(
      points={{-39,19.95},{36,19.95},{36,20},{110,20}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(on, booToRea.u) annotation (Line(points={{-120,30},{-84,30},{-84,90},{
          -62,90}}, color={255,0,255}));
  connect(booToRea.y, Val2.y) annotation (Line(
      points={{-39,90},{0,90},{0,52}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(booToRea.y, Val1.y) annotation (Line(
      points={{-39,90},{-14,90},{-14,-24},{-58,-24}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(valLin.port_2, HX.port_b2)
    annotation (Line(points={{8,4},{40,4}}, color={0,127,255}));
  connect(valLin.port_1, chi.port_a2)
    annotation (Line(points={{-12,4},{-14,4.2},{-40,4.2}}, color={0,127,255}));
  connect(valLin.port_3, jun2.port_1)
    annotation (Line(points={{-2,-6},{-2,-60},{-60,-60}}, color={0,127,255}));
  connect(on, booToRea1.u) annotation (Line(points={{-120,30},{-84,30},{-84,90},
          {-70,90},{-70,106},{8,106},{8,78},{18,78}}, color={255,0,255}));
  connect(booToRea1.y, valLin.y) annotation (Line(points={{41,78},{46,78},{46,
          24},{-2,24},{-2,16}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Line(
          points={{-80,72}},
          color={255,255,255},
          thickness=0.5),
        Rectangle(
          extent={{-72,64},{68,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-102,-55},{99,-65}},
          lineColor={238,46,47},
          pattern=LinePattern.None,
          fillColor={217,67,180},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,65},{101,55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{14,-18},{54,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,-18},{-16,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Backward,
          radius=45),
        Rectangle(
          extent={{-58,-6},{-54,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,-6},{-50,-6},{-56,0},{-62,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,6},{-50,6},{-56,0},{-62,6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-58,18},{-54,6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-50,20},{-50,20}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-28,6},{-24,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-28,18},{-24,-18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-32,-6},{-20,-6},{-26,6},{-32,-6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{-64,22},{-16,18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Forward,
          radius=45),
        Rectangle(
          extent={{-28,6},{-24,2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(
          extent={{14,20},{54,18}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,22},{22,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,22},{24,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{24,24},{28,-24}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{28,24},{32,-24}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,24},{36,-24}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{36,24},{40,-24}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,24},{44,-24}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,22},{46,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,22},{48,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,-16},{48,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,-16},{24,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,-16},{22,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,-16},{46,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{2,0}},   color={28,108,200}),
        Rectangle(
          extent={{22,22},{24,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,22},{22,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,-16},{22,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{44,22},{46,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{46,22},{48,16}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-62,-20}},
                               color={0,0,0}),
        Polygon(
          points={{-50,20},{-50,20}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(points={{-62,-20}},
                               color={0,0,0})}),                 Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HXTrim;
