import 'package:flutter/material.dart';
import '../models/drive_models.dart';
import '../services/file_services.dart';

class MobileDrive extends StatefulWidget {
  const MobileDrive({super.key});

  @override
  State<MobileDrive> createState() => _MobileDriveState();
}

class _MobileDriveState extends State<MobileDrive> {
  String selectedSection = 'Home';
  int selectedBottomTab = 0; // 0: Home, 1: Files, 2: Trash
  String selectedSubTab = 'Suggestions'; // For Home tab: Suggestions/Activity
  final FileService _fileService = FileService();
  List<DriveItem> allFiles = [];
  List<DriveItem> myDriveFiles = [];
  List<DriveItem> trashFiles = [];
  List<DriveItem> filteredFiles = [];
  bool isLoading = false;
  String searchQuery = '';

  // Dark Purple theme colors
  static const Color primaryPurple = Color(0xFF8B5CF6);
  static const Color lightPurple = Color(0xFF9333EA);
  static const Color darkPurple = Color(0xFF5B21B6);
  static const Color purpleAccent = Color(0xFFA855F7);
  static const Color darkBackground = Color(0xFF0F0F23);
  static const Color cardBackground = Color(0xFF1E1B3A);
  static const Color surfaceColor = Color(0xFF2D2A54);
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFFCBD5E1);
  static const Color textMuted = Color(0xFF64748B);
  static const Color borderColor = Color(0xFF475569);
  static const Color accentGlow = Color(0xFF4C1D95);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    myDriveFiles = [
      DriveItem(
        name: 'Master sheet',
        type: DriveItemType.spreadsheet,
        size: '12.5 MB',
        lastModified: '26 Jul',
        owner: 'me',
        location: 'My Drive',
      ),
      DriveItem(
        name: 'Resume22.pdf',
        type: DriveItemType.pdf,
        size: '2.1 MB',
        lastModified: '31 Jul',
        owner: 'me',
        location: 'My Drive',
      ),
      DriveItem(
        name: 'file101.pdf',
        type: DriveItemType.pdf,
        size: '1.8 MB',
        lastModified: '31 Jul',
        owner: 'me',
        location: 'My Drive',
      ),
      DriveItem(
        name: 'doc672.pdf',
        type: DriveItemType.pdf,
        size: '1.5 MB',
        lastModified: '31 Jul',
        owner: 'me',
        location: 'My Drive',
      ),
      DriveItem(
        name: 'apple.pdf',
        type: DriveItemType.pdf,
        size: '2.0 MB',
        lastModified: '31 Jul',
        owner: 'me',
        location: 'My Drive',
      ),
      DriveItem(
        name: 'Classroom',
        type: DriveItemType.folder,
        size: '',
        lastModified: '18/11/23',
        owner: 'me',
        location: 'My Drive',
      ),
      DriveItem(
        name: 'Colab Notebooks',
        type: DriveItemType.folder,
        size: '',
        lastModified: '25/10/23',
        owner: 'me',
        location: 'My Drive',
      ),
      DriveItem(
        name: 'CSE Notes',
        type: DriveItemType.folder,
        size: '',
        lastModified: '05/03/24',
        owner: 'me',
        location: 'My Drive',
      ),
    ];

    _updateFilteredFiles();
  }

  void _updateFilteredFiles() {
    switch (selectedBottomTab) {
      case 0: // Home tab - show suggestions/activity
        if (selectedSubTab == 'Suggestions') {
          filteredFiles = myDriveFiles.take(7).toList();
        } else {
          filteredFiles = [];
        }
        break;
      case 1: // Files tab - show all files
        filteredFiles = myDriveFiles;
        break;
      case 2: // Trash tab
        filteredFiles = trashFiles;
        break;
      default:
        filteredFiles = myDriveFiles;
    }

    if (searchQuery.isNotEmpty) {
      filteredFiles = filteredFiles
          .where((file) => file.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Column(
        children: [
          if (selectedBottomTab == 0) _buildTabBar(),
          if (selectedBottomTab != 0) _buildFilesHeader(),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: primaryPurple))
                : _buildContent(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: selectedBottomTab != 2
          ? FloatingActionButton(
              onPressed: () => _showNewMenu(context),
              backgroundColor: primaryPurple,
              elevation: 8,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: cardBackground,
      elevation: 0,
      shadowColor: primaryPurple.withOpacity(0.3),
      leading: Builder(
        builder: (context) => IconButton(
          onPressed: () => Scaffold.of(context).openDrawer(),
          icon: const Icon(Icons.menu, color: textPrimary),
        ),
      ),
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryPurple.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: primaryPurple.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.search, color: textSecondary),
            ),
            Expanded(
              child: TextField(
                style: const TextStyle(color: textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Search in Drive',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: textMuted),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                    _updateFilteredFiles();
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryPurple, lightPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: primaryPurple.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: cardBackground,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryPurple, darkPurple, accentGlow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryPurple.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [purpleAccent, lightPurple, primaryPurple],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.cloud, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'BockDrive',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: cardBackground,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(Icons.home, 'Home', 0),
                  _buildDrawerItem(Icons.folder, 'My Drive', 1),
                  _buildDrawerItem(Icons.access_time, 'Recent', 1),
                  _buildDrawerItem(Icons.star_outline, 'Starred', 1),
                  _buildDrawerItem(Icons.delete_outline, 'Trash', 2),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  surfaceColor.withOpacity(0.8),
                  cardBackground.withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryPurple.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: primaryPurple.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1.72 GB of 15 GB used',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 1.72 / 15,
                    backgroundColor: surfaceColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(primaryPurple),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {},
                  child: Text(
                    'Get more storage',
                    style: TextStyle(
                      fontSize: 12,
                      color: primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, int targetTab) {
    bool isSelected = (selectedSection == title) || 
        (title == 'Home' && selectedBottomTab == 0) ||
        (title == 'My Drive' && selectedBottomTab == 1) ||
        (title == 'Trash' && selectedBottomTab == 2);
        
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      decoration: BoxDecoration(
        gradient: isSelected 
            ? LinearGradient(
                colors: [primaryPurple.withOpacity(0.3), primaryPurple.withOpacity(0.1)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        borderRadius: BorderRadius.circular(12),
        border: isSelected 
            ? Border.all(color: primaryPurple.withOpacity(0.5), width: 1)
            : null,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? primaryPurple : textSecondary,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? textPrimary : textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          setState(() {
            selectedSection = title;
            selectedBottomTab = targetTab;
            if (title == 'Home') {
              selectedSubTab = 'Suggestions';
            }
            _updateFilteredFiles();
          });
        },
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedSubTab = 'Suggestions';
                  _updateFilteredFiles();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: selectedSubTab == 'Suggestions'
                      ? Border(
                          bottom: BorderSide(color: primaryPurple, width: 3),
                        )
                      : null,
                ),
                child: Text(
                  'Suggestions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedSubTab == 'Suggestions'
                        ? primaryPurple
                        : textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedSubTab = 'Activity';
                  _updateFilteredFiles();
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  border: selectedSubTab == 'Activity'
                      ? Border(
                          bottom: BorderSide(color: primaryPurple, width: 3),
                        )
                      : null,
                ),
                child: Text(
                  'Activity',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selectedSubTab == 'Activity'
                        ? primaryPurple
                        : textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilesHeader() {
    String headerText;
    switch (selectedBottomTab) {
      case 1:
        headerText = selectedSection == 'Recent' ? 'Recent' : 'My Drive';
        break;
      case 2:
        headerText = 'Trash';
        break;
      default:
        headerText = 'Files';
    }
    
    return Container(
      color: cardBackground,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            headerText,
            style: const TextStyle(
              fontSize: 18,
              color: textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            children: [
              if (selectedBottomTab == 1)
                Row(
                  children: [
                    Text(
                      'Name',
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                    Icon(Icons.arrow_upward, size: 16, color: textSecondary),
                    const SizedBox(width: 16),
                  ],
                ),
              Icon(Icons.grid_view, color: textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (selectedBottomTab == 0 && selectedSubTab == 'Activity') {
      return _buildActivityView();
    } else {
      return _buildFilesList();
    }
  }

  Widget _buildActivityView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: surfaceColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.timeline,
              size: 64,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No recent activity',
            style: TextStyle(
              fontSize: 18,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Activity from the last 30 days will appear here',
            style: TextStyle(
              fontSize: 14,
              color: textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilesList() {
    if (filteredFiles.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      color: darkBackground,
      child: ListView.builder(
        itemCount: filteredFiles.length,
        itemBuilder: (context, index) {
          return _buildMobileFileItem(filteredFiles[index]);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;
    
    if (selectedBottomTab == 2) {
      message = 'Trash is empty';
      icon = Icons.delete_outline;
    } else if (selectedBottomTab == 0 && selectedSubTab == 'Activity') {
      message = 'No recent activity';
      icon = Icons.timeline;
    } else {
      message = 'No files found';
      icon = Icons.folder_open;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: surfaceColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              icon,
              size: 64,
              color: textMuted,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (selectedBottomTab == 2) ...[
            const SizedBox(height: 12),
            Text(
              'Items in trash will be automatically deleted after 30 days',
              style: TextStyle(
                fontSize: 14,
                color: textMuted,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMobileFileItem(DriveItem item) {
    bool isInTrash = selectedBottomTab == 2;
    bool isHomeSuggestions = selectedBottomTab == 0 && selectedSubTab == 'Suggestions';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryPurple.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryPurple.withOpacity(0.3), primaryPurple.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryPurple.withOpacity(0.3)),
          ),
          child: Icon(
            _fileService.getFileIcon(item.type),
            color: primaryPurple,
            size: 28,
          ),
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isInTrash ? textMuted : textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            children: [
              if (!isInTrash && !isHomeSuggestions) ...[
                Text(
                  'Modified ${item.lastModified}',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ] else if (isHomeSuggestions) ...[
                Icon(Icons.people, size: 12, color: primaryPurple),
                const SizedBox(width: 4),
                Text(
                  'You opened • ${item.lastModified}',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ] else ...[
                Text(
                  'Deleted • ${item.lastModified}',
                  style: TextStyle(
                    fontSize: 12,
                    color: textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        trailing: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: IconButton(
            onPressed: () => _showFileOptions(context, item),
            icon: const Icon(Icons.more_vert, color: textSecondary),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: cardBackground,
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryPurple,
        unselectedItemColor: textMuted,
        backgroundColor: Colors.transparent,
        elevation: 0,
        currentIndex: selectedBottomTab,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: (index) {
          setState(() {
            selectedBottomTab = index;
            if (index == 0) {
              selectedSection = 'Home';
              selectedSubTab = 'Suggestions';
            } else if (index == 1) {
              selectedSection = 'My Drive';
            } else if (index == 2) {
              selectedSection = 'Trash';
            }
            _updateFilteredFiles();
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_outline),
            label: 'Trash',
          ),
        ],
      ),
    );
  }

  void _showNewMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: primaryPurple.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Create new',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 20),
            _buildMenuOption(Icons.create_new_folder, 'New folder', () => _handleNewAction('folder')),
            _buildMenuOption(Icons.upload_file, 'File upload', () => _handleNewAction('upload_file')),
            _buildMenuOption(Icons.drive_folder_upload, 'Folder upload', () => _handleNewAction('upload_folder')),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryPurple.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryPurple.withOpacity(0.3), primaryPurple.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primaryPurple),
        ),
        title: Text(title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.w500)),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  void _showFileOptions(BuildContext context, DriveItem item) {
    bool isInTrash = selectedBottomTab == 2;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: primaryPurple.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: textMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryPurple.withOpacity(0.3), primaryPurple.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _fileService.getFileIcon(item.type),
                    color: primaryPurple,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (!isInTrash) ...[
              _buildFileOption(Icons.open_in_new, 'Open', () => Navigator.pop(context)),
              _buildFileOption(Icons.share, 'Share', () => Navigator.pop(context)),
              _buildFileOption(Icons.download, 'Download', () => Navigator.pop(context)),
              _buildFileOption(Icons.delete_outline, 'Move to trash', () {
                Navigator.pop(context);
                _moveToTrash(item);
              }, isDestructive: true),
            ] else ...[
              _buildFileOption(Icons.restore, 'Restore', () {
                Navigator.pop(context);
                _restoreFromTrash(item);
              }),
              _buildFileOption(Icons.delete_forever, 'Delete forever', () {
                Navigator.pop(context);
                _deleteForeverConfirmation(item);
              }, isDestructive: true),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFileOption(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: surfaceColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDestructive ? Colors.red.withOpacity(0.3) : primaryPurple.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.2) : primaryPurple.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: isDestructive ? Colors.red : primaryPurple),
        ),
        title: Text(
          title, 
          style: TextStyle(
            color: isDestructive ? Colors.red : textPrimary, 
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _handleNewAction(String action) async {
    setState(() {
      isLoading = true;
    });

    try {
      switch (action) {
        case 'folder':
          await _createNewFolder();
          break;
        case 'upload_file':
          await _uploadFile();
          break;
        case 'upload_folder':
          await _uploadFolder();
          break;
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _createNewFolder() async {
    String folderName = 'Untitled folder';
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: folderName);
        return AlertDialog(
          backgroundColor: cardBackground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('New folder', style: TextStyle(color: textPrimary)),
          content: TextField(
            controller: controller,
            style: TextStyle(color: textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: surfaceColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryPurple.withOpacity(0.3)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: primaryPurple, width: 2),
              ),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: textMuted)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Create'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      final newFolder = DriveItem(
        name: result,
        type: DriveItemType.folder,
        size: '0 bytes',
        lastModified: 'Just now',
        owner: 'me',
        location: 'My Drive',
      );
      
      setState(() {
        myDriveFiles.insert(0, newFolder);
        _updateFilteredFiles();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Folder "$result" created successfully'),
            backgroundColor: primaryPurple,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _uploadFile() async {
    try {
      final result = await _fileService.pickFiles();
      if (result != null && result.isNotEmpty) {
        for (final file in result) {
          final newFile = DriveItem(
            name: file.name,
            type: _fileService.getFileTypeFromExtension(file.extension ?? ''),
            size: _fileService.formatFileSize(file.size),
            lastModified: 'Just now',
            owner: 'me',
            location: 'My Drive',
          );
          
          setState(() {
            myDriveFiles.insert(0, newFile);
          });
        }
        
        setState(() {
          _updateFilteredFiles();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${result.length} file(s) uploaded successfully'),
              backgroundColor: primaryPurple,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading files: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _uploadFolder() async {
    try {
      final result = await _fileService.pickDirectory();
      if (result != null) {
        final newFolder = DriveItem(
          name: result.split('/').last,
          type: DriveItemType.folder,
          size: 'Unknown',
          lastModified: 'Just now',
          owner: 'me',
          location: 'My Drive',
        );
        
        setState(() {
          myDriveFiles.insert(0, newFolder);
          _updateFilteredFiles();
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Folder uploaded successfully'),
              backgroundColor: primaryPurple,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading folder: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _moveToTrash(DriveItem item) {
    setState(() {
      myDriveFiles.remove(item);
      trashFiles.add(item.copyWith(location: 'Trash'));
      _updateFilteredFiles();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} moved to trash'),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              trashFiles.remove(item);
              myDriveFiles.add(item.copyWith(location: 'My Drive'));
              _updateFilteredFiles();
            });
          },
        ),
      ),
    );
  }

  void _restoreFromTrash(DriveItem item) {
    setState(() {
      trashFiles.remove(item);
      myDriveFiles.add(item.copyWith(location: 'My Drive'));
      _updateFilteredFiles();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} restored'),
        backgroundColor: primaryPurple,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteForeverConfirmation(DriveItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Delete forever?', style: TextStyle(color: textPrimary)),
        content: Text(
          'Are you sure you want to permanently delete "${item.name}"? This action cannot be undone.',
          style: TextStyle(color: textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteFromTrash(item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete forever'),
          ),
        ],
      ),
    );
  }

  void _deleteFromTrash(DriveItem item) {
    setState(() {
      trashFiles.remove(item);
      _updateFilteredFiles();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} deleted permanently'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}