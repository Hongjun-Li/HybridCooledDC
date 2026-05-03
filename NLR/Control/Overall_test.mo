within NLR.Control;
package Overall_test
  model Anti_freeze
      extends Modelica.Blocks.Icons.Block;
    Modelica.Blocks.Interfaces.RealOutput yMainValve
      annotation (Placement(transformation(extent={{100,30},{120,50}})));
    Modelica.Blocks.Interfaces.RealInput TCWRet
      annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
    Buildings.Controls.Continuous.LimPID bypassCon(
      k=1,
      Ti=60,
      Td=10,
      reverseActing=false,
      initType=Modelica.Blocks.Types.Init.InitialState)
      "Controller for freezing bypass"
      annotation (Placement(transformation(extent={{-20,30},{0,50}})));
    Modelica.Blocks.Sources.Constant no(k=1)
      annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
    Modelica.Blocks.Math.Feedback feedback
      annotation (Placement(transformation(extent={{50,-20},{70,-40}})));
    Modelica.Blocks.Interfaces.RealOutput yBypass
      annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
    Modelica.Blocks.Sources.Constant ReturnSet(k=273.15 + 3)
      annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  equation
    connect(no.y,feedback. u1)
      annotation (Line(points={{21,-30},{52,-30}},   color={0,0,127}));
    connect(bypassCon.y,feedback. u2) annotation (Line(points={{1,40},{60,40},{
            60,-22}},   color={0,0,127}));
    connect(feedback.y, yBypass)
      annotation (Line(points={{69,-30},{110,-30}}, color={0,0,127}));
    connect(bypassCon.y, yMainValve)
      annotation (Line(points={{1,40},{110,40}}, color={0,0,127}));
    connect(ReturnSet.y, bypassCon.u_s)
      annotation (Line(points={{-39,40},{-22,40}}, color={0,0,127}));
    connect(TCWRet, bypassCon.u_m) annotation (Line(points={{-120,-50},{-10,-50},
            {-10,28}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end Anti_freeze;

  model ahuCon
      extends Modelica.Blocks.Icons.Block;
    Modelica.Blocks.Interfaces.RealOutput uVal
      annotation (Placement(transformation(extent={{100,80},{120,100}})));
    Modelica.Blocks.Interfaces.RealInput TAirSup
      annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
    Modelica.Blocks.Interfaces.RealInput TAirRet
      annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
    Buildings.Controls.Continuous.LimPID ahuValSig(
      Ti=40,
      reverseActing=false,
      yMin=0.1,
      k=0.01)          "Valve position signal for the AHU"
      annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
    Modelica.Blocks.Sources.Constant TAirSupSet(k=273.15 + 21)
      "Supply air temperature setpoint"
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
    Modelica.Blocks.Sources.Constant phiAirRetSet(k=0.5)
      "Return air relative humidity setpoint"
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
    Buildings.Utilities.Psychrometrics.X_pTphi
                                     XAirSupSet(use_p_in=false)
      "Mass fraction setpoint of supply air "
      annotation (Placement(transformation(extent={{-20,20},{0,0}})));
    Modelica.Blocks.Sources.Constant TAirRetSet(k=273.15 + 30.22)
      "Return air temperature setpoint"
      annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
    Buildings.Controls.Continuous.LimPID ahuFanSpeCon(
      k=0.1,
      reverseActing=false,
      yMin=0.2,
      Ti=240) "Fan speed controller "
      annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
    Modelica.Blocks.Interfaces.RealOutput XSet_w
      annotation (Placement(transformation(extent={{100,0},{120,20}})));
    Modelica.Blocks.Interfaces.RealOutput uFan
      annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  equation
    connect(TAirRetSet.y,ahuFanSpeCon. u_s)
      annotation (Line(points={{-79,-30},{38,-30}},    color={0,0,127}));
    connect(TAirSupSet.y,ahuValSig. u_s)
      annotation (Line(points={{-79,90},{-42,90}},   color={0,0,127}));
    connect(TAirRetSet.y,XAirSupSet. T) annotation (Line(points={{-79,-30},{-32,
            -30},{-32,10},{-22,10}},     color={0,0,127}));
    connect(phiAirRetSet.y,XAirSupSet. phi) annotation (Line(points={{-79,30},{
            -32,30},{-32,16},{-22,16}},  color={0,0,127}));
    connect(XAirSupSet.X[1], XSet_w)
      annotation (Line(points={{1,10},{110,10}}, color={0,0,127}));
    connect(TAirRet, ahuFanSpeCon.u_m)
      annotation (Line(points={{-120,-90},{50,-90},{50,-42}},
                                                           color={0,0,127}));
    connect(TAirSup, ahuValSig.u_m) annotation (Line(points={{-120,50},{-30,50},
            {-30,78}},        color={0,0,127}));
    connect(ahuFanSpeCon.y, uFan)
      annotation (Line(points={{61,-30},{110,-30}}, color={0,0,127}));
    connect(ahuValSig.y, uVal)
      annotation (Line(points={{-19,90},{110,90}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end ahuCon;

  model NLRdataset
      extends Modelica.Blocks.Icons.Block;
      parameter Real interval=300;

    Modelica.Blocks.Interfaces.RealOutput yAir
      annotation (Placement(transformation(extent={{100,80},{120,100}})));
    Modelica.Blocks.Interfaces.RealOutput yLiq
      annotation (Placement(transformation(extent={{100,-20},{120,0}})));
    Modelica.Blocks.Math.Gain QflowAir(k=1000)
      annotation (Placement(transformation(extent={{-20,80},{0,100}})));
    Modelica.Blocks.Math.Gain QflowLiq(k=1000)
      annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
    Modelica.Blocks.Sources.CombiTimeTable NLRdata(
      tableOnFile=true,
      tableName="tab1",
      fileName="C:\\NLR_DC\\NLR\\Resources\\NLR_data\\NREL_HPCDC_modelica.txt",
      columns={2,3,4,5,6,7},
      startTime=20995200,
      shiftTime=20995200)
      annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
    Modelica.Blocks.Discrete.Sampler sampler1(samplePeriod=interval)
      annotation (Placement(transformation(extent={{40,80},{60,100}})));
    Modelica.Blocks.Math.Gain TsupAir(k=1)
      annotation (Placement(transformation(extent={{-20,40},{0,60}})));
    Modelica.Blocks.Math.Gain TretAir(k=1)
      annotation (Placement(transformation(extent={{-20,10},{0,30}})));
    Modelica.Blocks.Discrete.Sampler sampler2(samplePeriod=interval)
      annotation (Placement(transformation(extent={{40,40},{60,60}})));
    Modelica.Blocks.Discrete.Sampler sampler3(samplePeriod=interval)
      annotation (Placement(transformation(extent={{40,10},{60,30}})));
    Modelica.Blocks.Discrete.Sampler sampler4(samplePeriod=interval)
      annotation (Placement(transformation(extent={{40,-20},{60,0}})));
    Modelica.Blocks.Interfaces.RealOutput yTsupAirNLR
      annotation (Placement(transformation(extent={{100,40},{120,60}})));
    Modelica.Blocks.Interfaces.RealOutput yTretAirNLR
      annotation (Placement(transformation(extent={{100,10},{120,30}})));
    Modelica.Blocks.Math.Gain TsupLiq(k=1)
      annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
    Modelica.Blocks.Math.Gain TretLiq(k=1)
      annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
    Modelica.Blocks.Discrete.Sampler sampler5(samplePeriod=interval)
      annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
    Modelica.Blocks.Discrete.Sampler sampler6(samplePeriod=interval)
      annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
    Modelica.Blocks.Interfaces.RealOutput yTsupLiqNLR
      annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
    Modelica.Blocks.Interfaces.RealOutput yTretLiqNLR
      annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  equation
    connect(NLRdata.y[4], QflowLiq.u) annotation (Line(points={{-59,10},{-32,10},{
            -32,-10},{-22,-10}}, color={0,0,127}));
    connect(sampler1.y, yAir)
      annotation (Line(points={{61,90},{110,90}}, color={0,0,127}));
    connect(sampler1.u, QflowAir.y)
      annotation (Line(points={{38,90},{1,90}}, color={0,0,127}));
    connect(NLRdata.y[1], QflowAir.u) annotation (Line(points={{-59,10},{-32,10},{
            -32,90},{-22,90}}, color={0,0,127}));
    connect(NLRdata.y[2], TsupAir.u) annotation (Line(points={{-59,10},{-32,10},{-32,
            50},{-22,50}}, color={0,0,127}));
    connect(QflowLiq.y, sampler4.u)
      annotation (Line(points={{1,-10},{38,-10}}, color={0,0,127}));
    connect(sampler4.y, yLiq)
      annotation (Line(points={{61,-10},{110,-10}}, color={0,0,127}));
    connect(sampler2.y, yTsupAirNLR)
      annotation (Line(points={{61,50},{110,50}}, color={0,0,127}));
    connect(TsupAir.y, sampler2.u)
      annotation (Line(points={{1,50},{38,50}}, color={0,0,127}));
    connect(TretAir.y, sampler3.u)
      annotation (Line(points={{1,20},{38,20}}, color={0,0,127}));
    connect(sampler3.y, yTretAirNLR)
      annotation (Line(points={{61,20},{110,20}}, color={0,0,127}));
    connect(NLRdata.y[3], TretAir.u) annotation (Line(points={{-59,10},{-32,10},{-32,
            20},{-22,20}}, color={0,0,127}));
    connect(sampler5.y, yTsupLiqNLR)
      annotation (Line(points={{61,-50},{110,-50}}, color={0,0,127}));
    connect(TsupLiq.y, sampler5.u)
      annotation (Line(points={{1,-50},{38,-50}}, color={0,0,127}));
    connect(TretLiq.y, sampler6.u)
      annotation (Line(points={{1,-80},{38,-80}}, color={0,0,127}));
    connect(sampler6.y, yTretLiqNLR)
      annotation (Line(points={{61,-80},{110,-80}}, color={0,0,127}));
    connect(NLRdata.y[5], TsupLiq.u) annotation (Line(points={{-59,10},{-32,10},
            {-32,-50},{-22,-50}}, color={0,0,127}));
    connect(NLRdata.y[6], TretLiq.u) annotation (Line(points={{-59,10},{-32,10},
            {-32,-80},{-22,-80}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
      experiment(
        StartTime=20995200,
        StopTime=52531200,
        Interval=600,
        __Dymola_Algorithm="Dassl"));
  end NLRdataset;

  model MixCon
      extends Modelica.Blocks.Icons.Block;
    Modelica.Blocks.Interfaces.RealOutput uVal
      annotation (Placement(transformation(extent={{100,20},{120,40}})));
    Modelica.Blocks.Interfaces.RealInput TCDUEnt
      annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
    Buildings.Controls.Continuous.LimPID mixValSig(
      Ti=40,
      yMax=1,
      reverseActing=false,
      yMin=0,
      k=0.01) "Valve position signal for the Mixing valve"
      annotation (Placement(transformation(extent={{0,20},{20,40}})));
    Modelica.Blocks.Sources.Constant TLiqSupSet(k=273.15 + 23.35)
      "Supply liquid temperature setpoint"
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  equation
    connect(TLiqSupSet.y, mixValSig.u_s)
      annotation (Line(points={{-39,30},{-2,30}}, color={0,0,127}));
    connect(TCDUEnt, mixValSig.u_m)
      annotation (Line(points={{-120,-30},{10,-30},{10,18}}, color={0,0,127}));
    connect(mixValSig.y, uVal)
      annotation (Line(points={{21,30},{110,30}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end MixCon;

  model CWpumCon
      parameter Modelica.Units.SI.MassFlowRate mCHW_flow_nominal "Nominal mass flow rate at chilled water";
      extends Modelica.Blocks.Icons.Block;
    Modelica.Blocks.Interfaces.RealOutput uCHWpum
      annotation (Placement(transformation(extent={{100,20},{120,40}})));
    Modelica.Blocks.Interfaces.RealInput TCHWRet
      annotation (Placement(transformation(extent={{-140,-30},{-100,10}})));
    Modelica.Blocks.Math.Gain CHWmassflow(k=mCHW_flow_nominal)
      annotation (Placement(transformation(extent={{10,20},{30,40}})));
    Buildings.Controls.Continuous.LimPID CHWPumMasCon(
      k=0.1,
      reverseActing=false,
      yMin=0.1,
      Ti=240) annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    Modelica.Blocks.Sources.Constant TLiqRetSet(k=273.15 + 23.35)
      "Return liq temperature setpoint"
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  equation
    connect(CHWmassflow.y, uCHWpum)
      annotation (Line(points={{31,30},{110,30}}, color={0,0,127}));
    connect(CHWPumMasCon.y, CHWmassflow.u)
      annotation (Line(points={{-19,30},{8,30}}, color={0,0,127}));
    connect(TLiqRetSet.y, CHWPumMasCon.u_s)
      annotation (Line(points={{-59,30},{-42,30}}, color={0,0,127}));
    connect(TCHWRet, CHWPumMasCon.u_m) annotation (Line(points={{-120,-10},{-30,
            -10},{-30,18}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end CWpumCon;

  model CTCon
      extends Modelica.Blocks.Icons.Block;
    Modelica.Blocks.Interfaces.RealInput TCWRet
      annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
    Modelica.Blocks.Interfaces.RealOutput uFan
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Buildings.Controls.Continuous.LimPID
                               conFan(
      k=1,
      Ti=60,
      Td=10,
      reverseActing=false,
      initType=Modelica.Blocks.Types.Init.InitialState)
      "Controller for tower fan"
      annotation (Placement(transformation(extent={{0,20},{20,40}})));
    Modelica.Blocks.Sources.RealExpression TCWWet(y=min(23.89 + 273.15, max(
          273.15 + 12.78, weaBus.TWetBul + 3)))
      "Condenser water supply temperature setpoint"
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
      annotation (Placement(transformation(extent={{90,50},{110,70}})));
  equation
    connect(TCWWet.y, conFan.u_s)
      annotation (Line(points={{-19,30},{-2,30}}, color={0,0,127}));
    connect(conFan.y, uFan) annotation (Line(points={{21,30},{80,30},{80,0},{
            110,0}}, color={0,0,127}));
    connect(TCWRet, conFan.u_m)
      annotation (Line(points={{-120,0},{10,0},{10,18}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end CTCon;

  model RetCon
      extends Modelica.Blocks.Icons.Block;
    Modelica.Blocks.Interfaces.RealOutput uVal
      annotation (Placement(transformation(extent={{100,-10},{120,10}})));
    Modelica.Blocks.Interfaces.RealInput TCDULea
      annotation (Placement(transformation(extent={{-20,-20},{20,20}},
          rotation=90,
          origin={0,-120})));
    Modelica.Blocks.Sources.Constant TLiqRetSet(k=273.15 + 36.5)
      "Ret CHW temperature setpoint"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    Buildings.Controls.Continuous.LimPID ValSig(
      Ti=40,
      yMax=1,
      reverseActing=false,
      yMin=0,
      k=0.01) "Valve position signal for the 3way valve"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  equation
    connect(TLiqRetSet.y, ValSig.u_s)
      annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
    connect(ValSig.y, uVal)
      annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
    connect(TCDULea, ValSig.u_m)
      annotation (Line(points={{0,-120},{0,-12}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end RetCon;
end Overall_test;
