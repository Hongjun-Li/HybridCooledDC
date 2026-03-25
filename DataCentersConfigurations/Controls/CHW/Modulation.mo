within DataCentersConfigurations.Controls.CHW;
model Modulation
  Modelica.Blocks.Interfaces.IntegerInput u annotation (Placement(
        transformation(extent={{-120,-50},{-80,-10}}), iconTransformation(
          extent={{-120,-50},{-80,-10}})));
  Modelica.Blocks.Math.IntegerToReal integerToReal
    annotation (Placement(transformation(extent={{-78,-6},{-66,6}})));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1Ds(table=[1,0,1; 2,1,1; 3,1,0])
    annotation (Placement(transformation(extent={{-56,-10},{-36,10}})));
  Modelica.Blocks.Interfaces.RealInput Archi annotation (Placement(
        transformation(extent={{-120,10},{-80,50}}), iconTransformation(extent=
            {{-120,10},{-80,50}})));
  Modelica.Blocks.Tables.CombiTable1Ds Equipment_Availability(table=[1,1,0; 2,1,
        1; 3,0,1; 4,1,0; 5,1,1; 6,0,1; 7,1,0; 8,1,1; 9,0,1; 10,1,0; 11,1,1; 12,
        0,1]) annotation (Placement(transformation(extent={{-58,42},{-38,62}})));
  Modelica.Blocks.Math.Product WSE
    annotation (Placement(transformation(extent={{8,20},{28,40}})));
  Modelica.Blocks.Math.Product Chi
    annotation (Placement(transformation(extent={{-8,-20},{12,0}})));
  Modelica.Blocks.Math.Feedback CHIBypass
    annotation (Placement(transformation(extent={{72,-54},{84,-66}})));
  Modelica.Blocks.Sources.Constant const1(k=1)
    annotation (Placement(transformation(extent={{-10,-64},{-2,-56}})));
  Modelica.Blocks.Math.Feedback wseBypass
    annotation (Placement(transformation(extent={{54,42},{66,54}})));
  Modelica.Blocks.Sources.Constant const2(k=1)
    annotation (Placement(transformation(extent={{26,58},{34,66}})));
  Modelica.Blocks.Interfaces.RealOutput ValveChi annotation (Placement(
        transformation(extent={{94,-20},{114,0}}), iconTransformation(extent={{96,-10},
            {116,10}})));
  Modelica.Blocks.Interfaces.RealOutput ValveWSE annotation (Placement(
        transformation(extent={{94,20},{114,40}}),  iconTransformation(extent={{96,-40},
            {116,-20}})));
  Modelica.Blocks.Interfaces.RealOutput WSEbypass annotation (Placement(
        transformation(extent={{94,44},{114,64}}),   iconTransformation(extent={{96,-70},
            {116,-50}})));
  Modelica.Blocks.Interfaces.RealOutput ChillerBypass annotation (Placement(
        transformation(extent={{94,-70},{114,-50}}),
                                                   iconTransformation(extent={{96,20},
            {116,40}})));
  Modelica.Blocks.Math.RealToBoolean ChiOn(threshold=0.5)
    annotation (Placement(transformation(extent={{82,-36},{90,-28}})));
  Modelica.Blocks.Interfaces.BooleanOutput Chion annotation (Placement(
        transformation(extent={{94,-42},{114,-22}}),iconTransformation(extent={{96,50},
            {116,70}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{26,-20},{46,0}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-32,-50},{-12,-30}})));
  Modelica.Blocks.Sources.Constant const3(k=0)
    annotation (Placement(transformation(extent={{-60,-36},{-52,-28}})));
  Modelica.Blocks.Sources.Constant const4(k=1)
    annotation (Placement(transformation(extent={{-60,-54},{-52,-46}})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-72,-44},{-64,-36}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax=1, uMin=0)
    annotation (Placement(transformation(extent={{54,-20},{74,0}})));
equation
  connect(u, integerToReal.u) annotation (Line(points={{-100,-30},{-94,-30},{
          -94,0},{-79.2,0}}, color={255,127,0}));
  connect(integerToReal.y, combiTable1Ds.u)
    annotation (Line(points={{-65.4,0},{-58,0}}, color={0,0,127}));
  connect(Equipment_Availability.u, Archi) annotation (Line(points={{-60,52},{
          -84,52},{-84,30},{-100,30}}, color={0,0,127}));
  connect(combiTable1Ds.y[1], Chi.u2) annotation (Line(points={{-35,0},{-20,0},
          {-20,-16},{-10,-16}}, color={0,0,127}));
  connect(Equipment_Availability.y[2], Chi.u1) annotation (Line(points={{-37,52},
          {-16,52},{-16,-4},{-10,-4}}, color={0,0,127}));
  connect(Equipment_Availability.y[1], WSE.u2) annotation (Line(points={{-37,52},
          {-16,52},{-16,24},{6,24}}, color={0,0,127}));
  connect(combiTable1Ds.y[2], WSE.u1) annotation (Line(points={{-35,0},{-20,0},
          {-20,36},{6,36}}, color={0,0,127}));
  connect(const1.y, CHIBypass.u1)
    annotation (Line(points={{-1.6,-60},{73.2,-60}}, color={0,0,127}));
  connect(const2.y, wseBypass.u1) annotation (Line(points={{34.4,62},{50,62},{
          50,48},{55.2,48}}, color={0,0,127}));
  connect(wseBypass.u2, WSE.y)
    annotation (Line(points={{60,43.2},{60,30},{29,30}}, color={0,0,127}));
  connect(ValveWSE, WSE.y)
    annotation (Line(points={{104,30},{29,30}}, color={0,0,127}));
  connect(wseBypass.y, WSEbypass) annotation (Line(points={{65.4,48},{88,48},{
          88,54},{104,54}}, color={0,0,127}));
  connect(ChillerBypass, CHIBypass.y)
    annotation (Line(points={{104,-60},{83.4,-60}}, color={0,0,127}));
  connect(ChiOn.y, Chion)
    annotation (Line(points={{90.4,-32},{104,-32}}, color={255,0,255}));
  connect(Chi.y, add.u1) annotation (Line(points={{13,-10},{18,-10},{18,-4},{24,
          -4}}, color={0,0,127}));
  connect(switch1.y, add.u2) annotation (Line(points={{-11,-40},{16,-40},{16,
          -16},{24,-16}}, color={0,0,127}));
  connect(const3.y, switch1.u1)
    annotation (Line(points={{-51.6,-32},{-34,-32}}, color={0,0,127}));
  connect(const4.y, switch1.u3) annotation (Line(points={{-51.6,-50},{-42,-50},
          {-42,-48},{-34,-48}}, color={0,0,127}));
  connect(realToBoolean.y, switch1.u2)
    annotation (Line(points={{-63.6,-40},{-34,-40}}, color={255,0,255}));
  connect(realToBoolean.u, Equipment_Availability.y[1]) annotation (Line(points
        ={{-72.8,-40},{-76,-40},{-76,-14},{-32,-14},{-32,52},{-37,52}}, color={
          0,0,127}));
  connect(limiter.u, add.y)
    annotation (Line(points={{52,-10},{47,-10}}, color={0,0,127}));
  connect(limiter.y, ValveChi)
    annotation (Line(points={{75,-10},{104,-10}}, color={0,0,127}));
  connect(ChiOn.u, limiter.y) annotation (Line(points={{81.2,-32},{78,-32},{78,
          -10},{75,-10}}, color={0,0,127}));
  connect(CHIBypass.u2, limiter.y)
    annotation (Line(points={{78,-55.2},{78,-10},{75,-10}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Modulation;
