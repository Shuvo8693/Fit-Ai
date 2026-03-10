import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// MODELS
// ═══════════════════════════════════════════════════════════════════════════════

enum _SessionType { virtualTherapy, followUpChat }

class _Session {
  final String dateLabel;
  final String time;
  final String clientName;
  final _SessionType type;
  final String? aiNote;

  const _Session({
    required this.dateLabel,
    required this.time,
    required this.clientName,
    required this.type,
    this.aiNote,
  });
}

// ═══════════════════════════════════════════════════════════════════════════════
// TRAINER HOME SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int _selectedTab = 4; // Schedules tab active
  int _selectedDayIndex = 3; // Tuesday 22 highlighted
  bool _showCalendar = false;
  int _selectedCalDay = 16; // Jan 16 highlighted

  final List<String> _dayLabels = ['Tue', 'Tue', 'Tue', 'Tue', 'Tue', 'Tue'];
  final List<int> _dayNumbers = [19, 19, 19, 22, 23, 24];
  final List<bool> _hasDot = [false, false, false, true, false, false];

  final List<_Session> _sessions = const [
    _Session(
      dateLabel: '25 DEC',
      time: '10:30 AM',
      clientName: 'Smith III',
      type: _SessionType.virtualTherapy,
    ),
    _Session(
      dateLabel: '12 NOV',
      time: '08:45 AM',
      clientName: 'Smith III',
      type: _SessionType.followUpChat,
      aiNote:
          'revising her approach while enjoying a soothing massage to ease tension and enhance wellness.',
    ),
    _Session(
      dateLabel: '05 MAR',
      time: '02:15 PM',
      clientName: 'Smith III',
      type: _SessionType.virtualTherapy,
    ),
    _Session(
      dateLabel: '30 APR',
      time: '11:00 AM',
      clientName: 'Smith III',
      type: _SessionType.followUpChat,
      aiNote:
          'revising her approach while enjoying a soothing massage to ease tension and enhance wellness.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            _TrainerAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.h),
                    // Schedule summary
                    _ScheduleSummaryCard(
                      sessionToday: _selectedDayIndex == 3 ? 5 : 0,
                      needAttention: _selectedDayIndex == 3 ? 4 : 0,
                    ),
                    SizedBox(height: 16.h),

                    // Schedule timeline
                    _ScheduleTimelineSection(
                      dayLabels: _dayLabels,
                      dayNumbers: _dayNumbers,
                      hasDot: _hasDot,
                      selectedIndex: _selectedDayIndex,
                      showCalendar: _showCalendar,
                      selectedCalDay: _selectedCalDay,
                      onDaySelected: (i) => setState(() => _selectedDayIndex = i),
                      onToggleCalendar: () => setState(() => _showCalendar = !_showCalendar),
                      onCalDaySelected: (d) => setState(() => _selectedCalDay = d),
                    ),
                    SizedBox(height: 12.h),

                    // Sessions list or empty
                    if (_selectedDayIndex != 3)
                      _EmptySchedule()
                    else
                      ..._sessions.map(
                        (s) => _SessionCard(
                          session: s,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const SessionDetailsScreen()),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            _BottomNavBar(
              selected: _selectedTab,
              onChanged: (i) => setState(() => _selectedTab = i),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Trainer App Bar ──────────────────────────────────────────────────────────
class _TrainerAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22.r,
            backgroundImage: const NetworkImage(
              'https://images.unsplash.com/photo-1552058544-f2b08422138a?w=200',
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Hi Maxime !',
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.black)),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.w, height: 6.w,
                            decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                          ),
                          SizedBox(width: 4.w),
                          Text('Online',
                              style: TextStyle(fontSize: 10.sp, color: const Color(0xFF4CAF50), fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text("Let's Manage your  users",
                    style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 38.w, height: 38.h,
                decoration: BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                ),
                child: Icon(Icons.notifications_none, size: 20.sp, color: Colors.black87),
              ),
              Positioned(
                top: -3.h, right: -2.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF7A00),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text('5', style: TextStyle(fontSize: 9.sp, color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Schedule Summary ─────────────────────────────────────────────────────────
class _ScheduleSummaryCard extends StatelessWidget {
  final int sessionToday;
  final int needAttention;

  const _ScheduleSummaryCard({required this.sessionToday, required this.needAttention});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Schedule summary',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.black)),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _SummaryStatCard(
                  icon: Icons.calendar_today_outlined,
                  label: 'Session today',
                  value: sessionToday,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _SummaryStatCard(
                  icon: Icons.assignment_late_outlined,
                  label: 'Need Attention',
                  value: needAttention,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int value;

  const _SummaryStatCard({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: Colors.black54),
          SizedBox(height: 8.h),
          Text(label, style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500)),
          SizedBox(height: 4.h),
          Text('$value',
              style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: Colors.black)),
        ],
      ),
    );
  }
}

// ─── Schedule Timeline ────────────────────────────────────────────────────────
class _ScheduleTimelineSection extends StatelessWidget {
  final List<String> dayLabels;
  final List<int> dayNumbers;
  final List<bool> hasDot;
  final int selectedIndex;
  final bool showCalendar;
  final int selectedCalDay;
  final ValueChanged<int> onDaySelected;
  final VoidCallback onToggleCalendar;
  final ValueChanged<int> onCalDaySelected;

  const _ScheduleTimelineSection({
    required this.dayLabels,
    required this.dayNumbers,
    required this.hasDot,
    required this.selectedIndex,
    required this.showCalendar,
    required this.selectedCalDay,
    required this.onDaySelected,
    required this.onToggleCalendar,
    required this.onCalDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Schedule timeline',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
              Row(
                children: [
                  _TimelineIconBtn(
                    icon: Icons.view_week_outlined,
                    active: !showCalendar,
                    onTap: onToggleCalendar,
                  ),
                  SizedBox(width: 6.w),
                  _TimelineIconBtn(
                    icon: Icons.calendar_month_outlined,
                    active: showCalendar,
                    onTap: onToggleCalendar,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 14.h),

          if (!showCalendar)
            // Week strip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(dayLabels.length, (i) {
                final isSelected = i == selectedIndex;
                return GestureDetector(
                  onTap: () => onDaySelected(i),
                  child: Column(
                    children: [
                      Text(dayLabels[i],
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isSelected ? Colors.black : Colors.grey.shade400,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          )),
                      SizedBox(height: 6.h),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFF7A00) : const Color(0xFFF5F5F5),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${dayNumbers[i]}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        width: 4.w, height: 4.h,
                        decoration: BoxDecoration(
                          color: hasDot[i] ? const Color(0xFFFF7A00) : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            )
          else
            // Mini calendar
            _MiniCalendar(selectedDay: selectedCalDay, onDaySelected: onCalDaySelected),
        ],
      ),
    );
  }
}

class _TimelineIconBtn extends StatelessWidget {
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _TimelineIconBtn({required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.w, height: 30.h,
        decoration: BoxDecoration(
          color: active ? Colors.black : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Icon(icon, size: 16.sp, color: active ? Colors.white : Colors.black54),
      ),
    );
  }
}

// ─── Mini Calendar ────────────────────────────────────────────────────────────
class _MiniCalendar extends StatelessWidget {
  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  const _MiniCalendar({required this.selectedDay, required this.onDaySelected});

  static const _weekDays = ['FR', 'SA', 'SU', 'MO', 'TU', 'WE', 'TH'];
  // January 2025 grid (starting from Fri Dec 27 to cover full weeks)
  static const _calRows = [
    [29, 30, 31, 1, 2, 3, 4],
    [5, 6, 7, 8, 9, 10, 11],
    [12, 13, 14, 15, 16, 17, 18],
    [19, 20, 21, 22, 23, 24, 25],
    [26, 27, 28, 29, 30, 1, 2],
  ];
  static const _prevMonthDays = {29, 30, 31};
  static const _nextMonthDays = {1, 2};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Month header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.chevron_left, size: 20.sp, color: Colors.black54),
            Text('January 2025',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700)),
            Icon(Icons.chevron_right, size: 20.sp, color: Colors.black54),
          ],
        ),
        SizedBox(height: 10.h),

        // Weekday headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _weekDays.map((d) => SizedBox(
            width: 32.w,
            child: Text(d,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade400, fontWeight: FontWeight.w600)),
          )).toList(),
        ),
        SizedBox(height: 6.h),

        // Day rows
        ..._calRows.map((row) => Padding(
          padding: EdgeInsets.only(bottom: 4.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: row.asMap().entries.map((e) {
              final day = e.value;
              final col = e.key;
              final isOtherMonth = _calRows.indexOf(row) == 0 && _prevMonthDays.contains(day)
                  || _calRows.indexOf(row) == 4 && _nextMonthDays.contains(day);
              final isSelected = day == selectedDay && !isOtherMonth;

              return GestureDetector(
                onTap: isOtherMonth ? null : () => onDaySelected(day),
                child: Container(
                  width: 32.w, height: 32.w,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFFFF7A00) : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      color: isSelected
                          ? Colors.white
                          : isOtherMonth
                              ? Colors.grey.shade300
                              : Colors.black87,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )),
      ],
    );
  }
}

// ─── Empty Schedule ───────────────────────────────────────────────────────────
class _EmptySchedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Container(
              width: 70.w, height: 70.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.event_busy_outlined, size: 30.sp, color: Colors.grey.shade400),
            ),
            SizedBox(height: 14.h),
            Text('No scheduled appointment to attend',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}

// ─── Session Card ─────────────────────────────────────────────────────────────
class _SessionCard extends StatelessWidget {
  final _Session session;
  final VoidCallback onTap;

  const _SessionCard({required this.session, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isVirtual = session.type == _SessionType.virtualTherapy;

    return GestureDetector(
      onTap: isVirtual ? onTap : null,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date column
            SizedBox(
              width: 52.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(session.dateLabel.split(' ')[0],
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.black)),
                  Text(session.dateLabel.split(' ')[1],
                      style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade400)),
                  SizedBox(height: 2.h),
                  Text(session.time,
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade400)),
                ],
              ),
            ),
            SizedBox(width: 10.w),

            // Card
            Expanded(
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isVirtual ? 'Virtual physical therapy session.' : 'Quick follow-up chat.',
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black),
                    ),
                    SizedBox(height: 3.h),
                    Text('Client:  ${session.clientName}',
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade400)),
                    SizedBox(height: 10.h),

                    if (isVirtual)
                      _OutlineActionBtn(
                        icon: Icons.phone_outlined,
                        label: 'Start call',
                        onTap: () {},
                      )
                    else ...[
                      if (session.aiNote != null) _AiNoteBox(note: session.aiNote!),
                      SizedBox(height: 10.h),
                      _OutlineActionBtn(
                        icon: Icons.chat_bubble_outline,
                        label: 'Message',
                        onTap: () {},
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiNoteBox extends StatelessWidget {
  final String note;

  const _AiNoteBox({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 12.sp, color: Colors.black54),
              SizedBox(width: 5.w),
              Text('AI Recommendation',
                  style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: Colors.black54)),
            ],
          ),
          SizedBox(height: 6.h),
          Text(note,
              style: TextStyle(fontSize: 11.sp, color: Colors.black87, height: 1.5)),
        ],
      ),
    );
  }
}

class _OutlineActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OutlineActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 38.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15.sp, color: Colors.black87),
            SizedBox(width: 6.w),
            Text(label,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Nav Bar ───────────────────────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _BottomNavBar({required this.selected, required this.onChanged});

  static const _items = [
    (Icons.home_outlined, 'Home'),
    (Icons.people_outline, 'Clients'),
    (null, ''),
    (Icons.play_circle_outline, 'Contents'),
    (Icons.calendar_today_outlined, 'Schedules'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;

          // FAB center button
          if (item.$1 == null) {
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: 48.w, height: 48.h,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF7A00),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white, size: 26.sp),
              ),
            );
          }

          final isSelected = i == selected;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.$1, size: 22.sp,
                    color: isSelected ? const Color(0xFFFF7A00) : Colors.grey.shade400),
                SizedBox(height: 3.h),
                Text(item.$2,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: isSelected ? const Color(0xFFFF7A00) : Colors.grey.shade400,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    )),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// SESSION DETAILS SCREEN
// ═══════════════════════════════════════════════════════════════════════════════

class SessionDetailsScreen extends StatelessWidget {
  const SessionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: Container(
                      width: 34.w, height: 34.h,
                      decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
                      ),
                      child: Icon(Icons.chevron_left, size: 20.sp, color: Colors.black87),
                    ),
                  ),
                  Expanded(
                    child: Text('Session details',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700)),
                  ),
                  SizedBox(width: 34.w),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text('Virtual physical therapy\nsession.',
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w800, color: Colors.black, height: 1.3)),
                    SizedBox(height: 16.h),

                    // Date + Time row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Session Date',
                                  style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade400)),
                              SizedBox(height: 4.h),
                              Text('Tomorrow',
                                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
                              SizedBox(height: 4.h),
                              Row(
                                children: [
                                  Container(
                                    width: 6.w, height: 6.h,
                                    decoration: const BoxDecoration(color: Color(0xFFFF7A00), shape: BoxShape.circle),
                                  ),
                                  SizedBox(width: 5.w),
                                  Text('Rehab session',
                                      style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Time', style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade400)),
                            SizedBox(height: 4.h),
                            Text('06:30 PM',
                                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // Session note
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Session note',
                              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade400)),
                          SizedBox(height: 8.h),
                          Text(
                            'A live, one-on-one virtual session focused on assessing movement, reducing pain, and supporting recovery. The therapist reviews progress, guides personalized exercises, and adjusts the treatment plan to improve mobility and function conveniently from home.',
                            style: TextStyle(fontSize: 12.sp, color: Colors.black87, height: 1.6),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // Session ID
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                      ),
                      child: Row(
                        children: [
                          Text('Session ID : ',
                              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade400)),
                          Text('#150-250-5420',
                              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: Colors.black87)),
                        ],
                      ),
                    ),
                    SizedBox(height: 18.h),

                    // Client section
                    Text('Client',
                        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.black)),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 22.r,
                                backgroundImage: const NetworkImage(
                                  'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Ethan Rodriguez',
                                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700)),
                                    SizedBox(height: 3.h),
                                    Text('ID: 321-654-9870',
                                        style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade400)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8F5E9),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 5.w, height: 5.h,
                                      decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text('Online',
                                        style: TextStyle(fontSize: 10.sp, color: const Color(0xFF4CAF50), fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.videocam_outlined, size: 16.sp, color: Colors.black87),
                                        SizedBox(width: 5.w),
                                        Text('Call',
                                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.black87)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: 40.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF7A00),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.chat_bubble_outline, size: 14.sp, color: Colors.white),
                                        SizedBox(width: 5.w),
                                        Text('Message',
                                            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Cancel
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        alignment: Alignment.center,
                        child: Text('Cancel Schedule',
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black87)),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Reschedule
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.infinity,
                        height: 52.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A00),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        alignment: Alignment.center,
                        child: Text('Reschedule Session',
                            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
