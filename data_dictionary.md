## Data Dictionary for NASA Flight Data

###General 
 * It is not yet known if the flight hops make sense. Look at the lat/lon tracks to see if the next flight departs from the location that it landed at in the previous flight.
 * Times and dates are anonymized.
 * Latitude and longitude are not anonymized and should correspond to actual airports.
  * Here is a link to the data: https://c3.nasa.gov/dashlink/members/4/resources/?type=ds

###Known Anomalies
+------------+------+--------------------------------------------+---------------------+
|    Date    | Tail |                   Event                    |        File         |
+------------+------+--------------------------------------------+---------------------+
| 4/17/2002  |  660 | Engine Low Margin                          | 660200204172034.mat |
| 5/31/2002  |  661 | Engine Won't Maintain Idle                 | 661200205310644.mat |
| 7/17/2002  |  661 | Engine Slow Light Off                      | 661200207170742.mat |
| 5/30/2002  |  668 | Engine Hung (Twice)                        | 668200205300414.mat |
| 3/21/2003  |  670 | Over speed temperature and engine shutdown | 670200303221115.mat |
| 12/22/2003 |  670 | Loss of oil and engine shutdown            | 670200312232037.mat |
| 3/12/2003  |  681 | Hydraulic leak                             | 681200303120524.mat |
| 6/3/2002   |  656 | Engine Won't Start                         | 656200206031558.mat |
| 4/8/2002   |  658 | Engine Over-Temp                           | 658200204081423.mat |
+------------+------+--------------------------------------------+---------------------+

### Variables
 * Per Bryan Matthews, there is no authoritative description for the variables. 
 * Bryan suggests using Google to search FOQA parameters names to understand their meaning.
 * Ignore the LSP suffix on all parameters. It is an artifact of how words from the parameter bytes are combined in the conversion to engineering units. 
 * The meaning of the autopilot parameters us not known. The owners of the data were unable to find the documentation on how the modes were mapped.
 * Some of the binary state parameters are unintuitive. For example, LGDN shows 0 when you would expect the parameter to measure 1 to indicate that the landing gear is down. Since it looks like the opposite intuition is correct it is fairly easy to infer because we know landing gear is not deployed during cruise or for the majority of the flight. The Weight-on-Wheels WOW parameter is like this. You would expect WOW = 1 implies there is weight on wheels and hence plane is on the ground; WOW=0 otherwise. This is not the case. In fact, WOW=1 implies that airplane is airborne. Often these variables are merely the status of an electrical circuit – when the airplane is on the ground, the switch is forced “open” (by gravity) and closes (usually by spring action) when gravity stops to act. The WOW and LDGN is merely a indication of this circuit. 
 * Engine thrust is not measured by inferred. There are two surrogate values: (1) Engine fan speed (N1), (2) Engine Pressure Ratio (EPR). On this airplane N1 is used. The relationship between the surrogates is usually (piecewise) linear while the plane is cruising. Depending on the flight plan, the airplane needs to achieve certain speed at certain altitudes. This implies that the engines need to generate the corresponding thrust – based on payload and in some cases noise constraints.  This is the target or set point for thrust. The N1 Target is a lookup surrogate value corresponding to this thrust target. Usually the targets are set after the plane has completed its initial climb (before this the thrust is maximum). The actual speed of the airplane is also dependent on headwind and drag. Hence the target thrust must be corrected for these factors. After this correction is applied we get the commanded thrust. This is the total thrust the airplane is “demanding/requesting” from all four engines. The N1 Command is a lookup surrogate value corresponding to this thrust demand/request. The N1 command is provided to each of the four engines. Depending on the control system and aerodynamic behavior of the airplane, usually the outer engines try to follow this command, while the inner engines may get a secondary command – usually 90-95% value. In either case, all four engines try to follow the individual N1 command they request. Unfortunately this “per engine N1 command” is not recorded.  While this is a “request” there is an override factor called the N1 Compensation. Such overrides are necessary to avoid engine flameout, speed and pressure surge within the engines. The parameter N1CO reflects this. If N1CO is set to 0, no such overrides are applied and the engine will try to follow N1-Command. Typically N1CO will be “1” during the initial climb and final approach phase of the flight. The actual fan speeds achieved by the four engines are: N2.1, N2.2, N2.3 and N2.4. This will depend on the (a) age of the engine, (b) any sensor biases, (c) offsets in the fuel delivery system, (d) performance deterioration. Note that all four engines are controlled independently. 

-------------
 * ABRK-AIRBRAKE_POSITION
 * ACID-AIRCRAFT_NUMBER
 * ACMT-ACMS_TIMING_USED_T1HZ
 * AIL.1-AILERON_POSITION_LH
 * AIL.2-AILERON_POSITION_RH
 * ALT-PRESSURE_ALTITUDE_LSP
 * ALTR-ALTITUDE_RATE
 * ALTS-SELECTED_ALTITUDE_LSP
 * AOA1-ANGLE_OF_ATTACK_1
 * AOA2-ANGLE_OF_ATTACK_2
 * AOAC-CORRECTED_ANGLE_OF_ATTACK
 * AOAI-INDICATED_ANGLE_OF_ATTACK
 * APFD-AP_FD_STATUS - Auto Pilot Flight Director Status. The 3 modes of the Auto Pilot Flight Director are: 
   0. This could be a managed mode or the AP is turned off. Usually on the ground. 
   1. Automatic Mode – the pilot selects the mode (see LMOD, VMODE) and the control signals are calculated by the AP and executed by the flight controllers. 
   2. Manual mode – the pilot uses the stick and pedals to command the airplane. 
 * APUF-APU_FIRE_WARNING
 * A.T-THRUST_AUTOMATIC_ON
 * ATEN-A/T_ENGAGE_STATUS - ATEN is AUTO THRUST ENGAGE STATUS. 1 indicates that the auto throttle is engaged. That is the engine N1 target speed is automatically set based on navigation commands (flight plan). 
 * BAL1-BARO_CORRECT_ALTITUDE_LSP
 * BAL2-BARO_CORRECT_ALTITUDE_LSP
 * BLAC-BODY_LONGITUDINAL_ACCELERATION
 * BLV-BLEED_AIR_ALL_VALVES
 * BPGR.1-BRAKE_PRESSURE_LH_GREEN
 * BPGR.2-BRAKE_PRESSURE_RH_GREEN
 * BPYR.1-BRAKE_PRESSURE_LH_YELLOW
 * BPYR.2-BRAKE_PRESSURE_RH_YELLOW
 * CALT-CABIN_HIGH_ALTITUDE
 * CAS-COMPUTED_AIRSPEED_LSP
 * CASM-MAX_ALLOWABLE_AIRSPEED
 * CASS-SELECTED_AIRSPEED
 * CCPC-CONTROL_COLUMN_POSITION_CAPT
 * CCPF-CONTROL_COLUMN_POSITION_F/O
 * CRSS-SELECTED_COURSE
 * CTAC-CROSS_TRACK_ACCELERATION
 * CWPC-CONTROL_WHEEL_POSITION_CAPT
 * CWPF-CONTROL_WHEEL_POSITION_F/O
 * DA-DRIFT_ANGLE
 * DFGS-DFGS_1&2_MASTER
 * DVER.1-DATABASE_ID_VERSION_CHAR_1
 * DVER.2-DATABASE_ID_VERSION_CHAR_2
 * DWPT-DISTANCE_TO_WAYPOINT_LSP - Answer has not been confirmed yet.  It is suspected to be in nautical miles. It is a measure of the deviation from the final destination, and will reduce gradually to zero after the flight is complete. 
 * EAI-ENGINE_ANTICE_ALL_POSITIONS
 * ECYC.1-ENGINE_CYCLE_1_LSP
 * ECYC.2-ENGINE_CYCLE_2_LSP
 * ECYC.3-ENGINE_CYCLE_3_LSP
 * ECYC.4-ENGINE_CYCLE_4_LSP
 * EGT.1-EXHAUST_GAS_TEMPERATURE_1
 * EGT.2-EXHAUST_GAS_TEMPERATURE_2
 * EGT.3-EXHAUST_GAS_TEMPERATURE_3
 * EGT.4-EXHAUST_GAS_TEMPERATURE_4
 * EHRS.1-ENGINE_HOURS_1_LSP
 * EHRS.2-ENGINE_HOURS_2_LSP
 * EHRS.3-ENGINE_HOURS_3_LSP
 * EHRS.4-ENGINE_HOURS_4_LSP
 * ELEV.1-ELEVATOR_POSITION_LEFT
 * ELEV.2-ELEVATOR_POSITION_RIGHT
 * ESN.1-ENGINE_SERIAL_NUMBER_1_LSP
 * ESN.2-ENGINE_SERIAL_NUMBER_2_LSP
 * ESN.3-ENGINE_SERIAL_NUMBER_3_LSP
 * ESN.4-ENGINE_SERIAL_NUMBER_4_LSP
 * EVNT-EVENT_MARKER
 * FADF-FADEC_FAIL_ALL_ENGINES
 * FADS-FADEC_STATUS_ALL_ENGINES
 * FF.1-FUEL_FLOW_1
 * FF.2-FUEL_FLOW_2
 * FF.3-FUEL_FLOW_3
 * FF.4-FUEL_FLOW_4
 * FGC3-DFGS_STATUS_3
 * FIRE.1-ENGINE_FIRE_#1
 * FIRE.2-ENGINE_FIRE_#2
 * FIRE.3-ENGINE_FIRE_#3
 * FIRE.4-ENGINE_FIRE_#4
 * FLAP-T.E._FLAP_POSITION
 * FPAC-FLIGHT_PATH_ACCELERATION
 * FQTY.1-FUEL_QUANTITY_TANK_1_LSB
 * FQTY.2-FUEL_QUANTITY_TANK_2_LSB
 * FQTY.3-FUEL_QUANTITY_TANK_3_LSB
 * FQTY.4-FUEL_QUANTITY_TANK_4_LSB
 * FRMC-FRAME_COUNTER
 * GLS-GLIDESLOPE_DEVIATION
 * GPWS-GPWS_1-5
 * GS-GROUND_SPEED_LSP
 * HDGS-SELECTED_HEADING
 * HF1-HF_KEYING_#1
 * HF2-HF_KEYING_#2
 * HYDG-LOW_HYDRAULIC_PRESSURE_GREEN
 * HYDY-LOW_HYDRAULIC_PRESSURE_YELLOW
 * ILSF-ILS_FREQUENCY_LSP
 * IVV-INERTIAL_VERTICAL_SPEED_LSP
 * LATG-LATERAL_ACCELERATION
 * LATP-LATITUDE_POSITION_LSP
 * LGDN-GEARS_L&R_DOWN_LOCKED
 * LGUP-GEARS_L&R_UP_LOCKED	
 * LMOD-LATERAL_ENGAGE_MODES - Suspect this is used to track lateral cross track FMS response. The mode enumeration codes are currently being investigated. 
 * LOC-LOCALIZER_DEVIATION
 * LONG-LONGITUDINAL_ACCELERATION
 * LONP-LONGITUDE_POSITION_LSP MACH-MACH_LSP
 * MH-MAGNETIC_HEADING_LSP
 * MNS-SELECTED_MACH
 * MRK-MARKERS-_INNER,_MIDDLE,_OUTER
 * MSQT.1-SQUAT_SWITCH_LEFT_MAIN_GEAR
 * MSQT.2-SQUAT_SWITCH_RIGHT_MAIN_GEAR
 * MW-MASTER_WARNING
 * N1.1-FAN_SPEED_1_LSP
 * N1.2-FAN_SPEED_2_LSP
 * N1.3-FAN_SPEED_3_LSP
 * N1.4-FAN_SPEED_4_LSP
 * N1C-N1_COMMAND_LSP
 * N1CO-N1_COMPENSATION
 * N1T-N1_TARGET_LSP - The % of the maximum target fan speed setting for the engines.
 * N2.1-CORE_SPEED_1_LSP
 * N2.2-CORE_SPEED_2_LSP
 * N2.3-CORE_SPEED_3_LSP
 * N2.4-CORE_SPEED_4_LSP
 * NSQT-SQUAT_SWITCH_NOSE_MAIN_GEAR
 * OIP.1-OIL_PRESSURE_1
 * OIP.2-OIL_PRESSURE_2
 * OIP.3-OIL_PRESSURE_3
 * OIP.4-OIL_PRESSURE_4
 * OIPL-LOW_OIL_PRESSURE_ALL_ENGINES
 * OIT.1-OIL_TEMPERATURE_1
 * OIT.2-OIL_TEMPERATURE_2
 * OIT.3-OIL_TEMPERATURE_3
 * OIT.4-OIL_TEMPERATURE_4
 * PACK-PACK_AIR_CONDITIONING_ALL
 * PH-FLIGHT_PHASE_FROM_ACMS - Converted to a categorical variable from an number. The integer values are 0=Unknown, 1=Preflight, 2=Taxi, 3=Takeoff, 4=Climb, 5=Cruise, 6=Approach, 7=Rollout
 * PI-IMPACT_PRESSURE_LSP
 * PLA.1-POWER_LEVER_ANGLE_1
 * PLA.2-POWER_LEVER_ANGLE_2
 * PLA.3-POWER_LEVER_ANGLE_3
 * PLA.4-POWER_LEVER_ANGLE_4
 * POVT-PYLON_OVERHEAT_ALL_ENGINES
 * PS-STATIC_PRESSURE_LSP
 * PSA-AVARAGE_STATIC_PRESSURE_LSP
 * PT-TOTAL_PRESSURE_LSP
 * PTCH-PITCH_ANGLE_LSP
 * PTRM-PITCH_TRIM_POSITION
 * PUSH-STICK_PUSHER
 * RALT-RADIO_ALTITUDE_LSP
 * ROLL-ROLL_ANGLE_LSP
 * RUDD-RUDDER_POSITION
 * RUDP-RUDDER_PEDAL_POSITION
 * SAT-STATIC_AIR_TEMPERATURE
 * SHKR-STICK_SHAKER
 * SMKB-ANIMAL_BAY_SMOKE
 * SMOK-SMOKE_WARNING
 * SNAP-MANUAL_SNAPSHOT_SWITCH
 * SPL.1-ROLL_SPOILER_LEFT
 * SPL.2-ROLL_SPOILER_RIGHT
 * SPLG-SPOILER_DEPLOY_GREEN
 * SPLY-SPOILER_DEPLOY_YELLOW
 * TAI-TAIL_ANTICE_ON
 * TAS-TRUE_AIRSPEED_LSP
 * TAT-TOTAL_AIR_TEMPERATURE
 * TCAS-TCAS_LSP
 * TH-TRUE_HEADING_LSP
 * TMAG-TRUE/MAG_HEADING_SELECT
 * TMODE-THRUST_MODE - The mode enumeration codes are currently being investigated. 
 * TOCW-TAKEOFF_CONF_WARNING
 * TRK-TRACK_ANGLE_TRUE_LSP
 * TRKM-TRACK_ANGLE_MAG_LSP
 * VAR.1107-SYNC_WORD_FOR_SUBFRAME_1
 * VAR.2670-SYNC_WORD_FOR_SUBFRAME_2
 * VAR.5107-SYNC_WORD_FOR_SUBFRAME_3
 * VAR.6670-SYNC_WORD_FOR_SUBFRAME_4
 * VHF1-VHF_KEYING_#1
 * VHF2-VHF_KEYING_#2
 * VHF3-VHF_KEYING_#3
 * VIB.1-ENGINE_VIBRATION_1
 * VIB.2-ENGINE_VIBRATION_2
 * VIB.3-ENGINE_VIBRATION_3
 * VIB.4-ENGINE_VIBRATION_4
 * VMODE-VERTICAL_ENGAGE_MODES - Translational control for the plane controls the flight path of the airplane with respect to air data, heading and navigation signal. It provides outputs to an inner-loop controller that controls the pitch, roll and yaw of the airplane. There are two primary modes for translational control: VMODE is the vertical mode and LMOD is the Lateral mode. Within each mode, there are several selections a pilot can make. The enumerated integers of LMOD and VMODE reflect these selections. We are asking experts to get the exact enumeration codes. Here are some examples to start the thinking: 
In LMOD: the selection could be heading, instrument landing, capture, or follow pilot command In VMOD: the selection could be: speed, altitude, vertical speed, flight path, glide slope, or follow pilot commands. 
 * VRTG-VERTICAL_ACCELERATION
 * VSPS-SELECTED_VERTICAL_SPEED
 * WAI.1-INNER_WING_DEICE
 * WAI.2-OUTER_WING_ANTICE
 * WD-WIND_DIRECTION_TRUE
 * WOW-WEIGHT_ON_WHEELS
 * WS-WIND_SPEED
 * WSHR-WINDSHEAR_WARNING
 * TIME.SERIES
 * 
 * 