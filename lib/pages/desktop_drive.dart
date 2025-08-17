import 'package:flutter/material.dart';
import '../models/drive_models.dart';
import '../services/file_services.dart';

class DesktopDrive extends StatefulWidget {
  const DesktopDrive({super.key});

  @override
  State<DesktopDrive> createState() => _DesktopDriveState();
}

class _DesktopDriveState extends State<DesktopDrive> {
  String selectedSection = 'Home';
  final FileService _fileService = FileService();
  List<DriveItem> allFiles = [];
  List<DriveItem> myDriveFiles = [];
  List<DriveItem> recentFiles = [];
  List<DriveItem> trashFiles = [];
  List<DriveItem> filteredFiles = [];
  List<DriveItem> suggestedFolders = [];
  bool isLoading = false;
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Purple theme colors
  static const Color primaryPurple = Color(0xFF6B46C1);
  static const Color lightPurple = Color(0xFF9333EA);
  static const Color darkPurple = Color(0xFF4C1D95);
  static const Color purpleAccent = Color(0xFF8B5CF6);
  static const Color lightPurpleBackground = Color(0xFFF3F4F6);
  static const Color purpleLight = Color(0xFFEDE9FE);
  static const Color darkGrey = Color(0xFF1F2937);
  static const Color mediumGrey = Color(0xFF6B7280);
  static const Color lightGrey = Color(0xFF9CA3AF);

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Suggested folders for home page
    suggestedFolders = [
      DriveItem(
        name: 'Resume',
        type: DriveItemType.folder,
        size: '',
        lastModified: '',
        location: 'My Drive',
      ),
      DriveItem(
        name: 'Gssoc 25',
        type: DriveItemType.folder,
        size: '',
        lastModified: '',
        location: 'My Drive',
      ),
      DriveItem(
        name: '3rd sem',
        type: DriveItemType.folder,
        size: '',
        lastModified: '',
        location: 'Shared with me',
      ),
      DriveItem(
        name: 'Unit-4',
        type: DriveItemType.folder,
        size: '',
        lastModified: '',
        location: 'Shared with me',
      ),
    ];

    // My Drive files
    myDriveFiles = [
      DriveItem(
        name: 'Master sheet',
        type: DriveItemType.spreadsheet,
        size: '12.5 MB',
        lastModified: 'Jul 26, 2025',
        owner: 'me',
        location: 'My Drive',
      ),
      DriveItem(
        name: 'Project 1',
        type: DriveItemType.document,
        size: '2.1 MB',
        lastModified: 'Jul 24, 2025',
        owner: 'founder.bock...',
        location: '3. Harshitha ...',
      ),
      DriveItem(
        name: 'week -1 -CA-points',
        type: DriveItemType.spreadsheet,
        size: '1.8 MB',
        lastModified: 'Jul 26, 2025',
        owner: 'Varun Sai',
        location: 'Shared with ...',
      ),
    ];

    // Recent files
    recentFiles = [
      DriveItem(
        name: 'Resume Harshitha Shetty.pdf',
        type: DriveItemType.pdf,
        size: '2.3 MB',
        lastModified: 'Aug 5, 2025',
        owner: 'me',
        location: 'Resume',
        reasonSuggested: 'You opened',
      ),
      DriveItem(
        name: 'IMG_6430.PNG',
        type: DriveItemType.image,
        size: '4.1 MB',
        lastModified: 'Jul 25, 2025',
        owner: 'me',
        location: 'Gssoc 25',
        reasonSuggested: 'You opened',
      ),
      DriveItem(
        name: 'Resume Harshitha Shetty.pdf',
        type: DriveItemType.pdf,
        size: '2.3 MB',
        lastModified: 'Jul 14, 2025',
        owner: 'me',
        location: 'My Drive',
        reasonSuggested: 'You created',
      ),
      DriveItem(
        name: 'IMG_6431.PNG',
        type: DriveItemType.image,
        size: '3.8 MB',
        lastModified: 'Jul 25, 2025',
        owner: 'me',
        location: 'Gssoc 25',
        reasonSuggested: 'You uploaded',
      ),
    ];

    allFiles = [...myDriveFiles, ...recentFiles];
    _updateFilteredFiles();
  }

  void _updateFilteredFiles() {
    switch (selectedSection) {
      case 'Home':
        filteredFiles = recentFiles;
        break;
      case 'My Drive':
        filteredFiles = myDriveFiles;
        break;
      case 'Recent':
        filteredFiles = recentFiles;
        break;
      case 'Trash':
        filteredFiles = trashFiles;
        break;
      default:
        filteredFiles = allFiles;
    }

    if (searchQuery.isNotEmpty) {
      filteredFiles = filteredFiles
          .where((file) => file.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth < 1024 && screenWidth >= 768;
    final isMobile = screenWidth < 768;
    
    return Scaffold(
      backgroundColor: lightPurpleBackground,
      drawer: isMobile ? _buildMobileDrawer() : null,
      body: Row(
        children: [
          // Sidebar (hidden on mobile)
          if (!isMobile) _buildSidebar(isTablet),
          
          // Main Content
          Expanded(
            child: Column(
              children: [
                _buildTopBar(isMobile),
                Expanded(child: _buildContentArea()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer() {
    return Drawer(
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebar(bool isTablet) {
    return Container(
      width: isTablet ? 200 : 260,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebarContent() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryPurple, lightPurple, purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.cloud, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'BockDrive',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: darkGrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        
        // New Button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _showNewMenu(context),
              icon: const Icon(Icons.add, size: 20),
              label: const Text(
                'New',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: primaryPurple,
                elevation: 3,
                shadowColor: primaryPurple.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side: BorderSide(color: primaryPurple.withOpacity(0.2)),
                ),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Navigation Items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            children: [
              _buildNavItem(Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(Icons.folder_outlined, Icons.folder, 'My Drive'),
              _buildNavItem(Icons.access_time_outlined, Icons.access_time, 'Recent'),
              _buildNavItem(Icons.delete_outline, Icons.delete, 'Trash'),
            ],
          ),
        ),
        
        // Storage Info
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [purpleLight, lightPurpleBackground],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryPurple.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '1.72 GB of 15 GB used',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: mediumGrey,
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: 1.72 / 15,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(primaryPurple),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () {},
                child: const Text(
                  'Get more storage',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: primaryPurple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(bool isMobile) {
    return Container(
      constraints: BoxConstraints(
        minHeight: selectedSection == 'Home' ? (isMobile ? 100 : 120) : (isMobile ? 70 : 80),
      ),
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 24,
        vertical: isMobile ? 8 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedSection == 'Home') ...[
            // Search Bar (moved to top)
            Row(
              children: [
                if (isMobile)
                  IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu, color: mediumGrey),
                  ),
                Expanded(
                  child: Container(
                    height: 40,
                    constraints: BoxConstraints(
                      maxWidth: isMobile ? double.infinity : MediaQuery.of(context).size.width * 0.5,
                    ),
                    decoration: BoxDecoration(
                      color: lightPurpleBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryPurple.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.search, color: mediumGrey, size: 18),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search in Drive',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: mediumGrey, fontSize: 14),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                                _updateFilteredFiles();
                              });
                            },
                          ),
                        ),
                        if (!isMobile)
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.tune, color: mediumGrey, size: 18),
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: primaryPurple,
                  radius: 16,
                  child: const Text('H', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                ),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 16),
            // Welcome Text (moved below search)
            Text(
              'Welcome to BockDrive',
              style: TextStyle(
                fontSize: isMobile ? 20 : 28,
                fontWeight: FontWeight.w400,
                color: darkGrey,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ] else ...[
            Row(
              children: [
                if (isMobile)
                  IconButton(
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    icon: const Icon(Icons.menu, color: mediumGrey),
                  ),
                // Search Bar for other sections
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: lightPurpleBackground,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: primaryPurple.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.search, color: mediumGrey, size: 18),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Search in Drive',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: mediumGrey, fontSize: 14),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                                _updateFilteredFiles();
                              });
                            },
                          ),
                        ),
                        if (!isMobile)
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.tune, color: mediumGrey, size: 18),
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: primaryPurple,
                  radius: 16,
                  child: const Text('H', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 14)),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData outlineIcon, IconData filledIcon, String title) {
    bool isSelected = selectedSection == title;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? purpleLight : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(
          isSelected ? filledIcon : outlineIcon,
          color: isSelected ? primaryPurple : mediumGrey,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? primaryPurple : darkGrey,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
            fontSize: 14,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          setState(() {
            selectedSection = title;
            searchQuery = '';
            _searchController.clear();
            _updateFilteredFiles();
          });
          // Close drawer on mobile after selection
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        dense: true,
      ),
    );
  }

  Widget _buildContentArea() {
    if (selectedSection == 'Home') {
      return _buildHomeView();
    } else {
      return _buildFilesView();
    }
  }

  Widget _buildHomeView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter buttons - with proper horizontal scrolling
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterButton('Type'),
                  const SizedBox(width: 8),
                  _buildFilterButton('People'),
                  const SizedBox(width: 8),
                  _buildFilterButton('Modified'),
                  const SizedBox(width: 8),
                  _buildFilterButton('Location'),
                ],
              ),
            ),
          ),
          
          SizedBox(height: isMobile ? 24 : 32),
          
          // Suggested folders section
          _buildExpandableSection(
            'Suggested folders',
            suggestedFolders,
            isGrid: true,
          ),
          
          SizedBox(height: isMobile ? 24 : 32),
          
          // Suggested files section
          _buildExpandableSection(
            'Suggested files',
            filteredFiles,
            showTable: !isMobile,
            showCards: isMobile,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSection(String title, List<DriveItem> items, {
    bool isGrid = false,
    bool showTable = false,
    bool showCards = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.keyboard_arrow_down, color: mediumGrey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: darkGrey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        if (isGrid) ...[
          _buildFoldersGrid(items),
        ] else if (showTable) ...[
          _buildFilesTable(items),
        ] else if (showCards) ...[
          _buildMobileFileCards(items),
        ] else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) => _buildFileListItem(items[index]),
          ),
        ],
      ],
    );
  }

  // FIXED FOLDERS GRID - COMPLETELY OVERFLOW-FREE
  Widget _buildFoldersGrid(List<DriveItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;
        final isTablet = screenWidth < 1024 && screenWidth >= 768;
        
        // Responsive grid columns
        int crossAxisCount;
        double childAspectRatio;
        
        if (isMobile) {
          crossAxisCount = 1;
          childAspectRatio = 5.0;
        } else if (isTablet) {
          crossAxisCount = 2;
          childAspectRatio = 2.5;
        } else {
          crossAxisCount = (screenWidth / 250).floor().clamp(2, 4);
          childAspectRatio = 2.0;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => _buildFolderCard(items[index]),
        );
      },
    );
  }

  // COMPLETELY FIXED FOLDER CARD
  Widget _buildFolderCard(DriveItem item) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 200;
        
        return Card(
          elevation: 3,
          shadowColor: primaryPurple.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.white, purpleLight.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: isMobile
                  ? Row(
                      children: [
                        Icon(
                          Icons.folder,
                          color: primaryPurple,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: darkGrey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'In ${item.location}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: mediumGrey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        _buildFileOptionsButton(item),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.folder,
                              color: primaryPurple,
                              size: 24,
                            ),
                            const Spacer(),
                            _buildFileOptionsButton(item),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: darkGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'In ${item.location}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: mediumGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileFileCards(List<DriveItem> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 2,
          shadowColor: primaryPurple.withOpacity(0.1),
          child: ListTile(
            leading: Icon(
              _fileService.getFileIcon(item.type),
              color: primaryPurple,
              size: 24,
            ),
            title: Text(
              item.name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: darkGrey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${item.reasonSuggested ?? 'Recently modified'} • ${item.lastModified}',
              style: const TextStyle(fontSize: 12, color: mediumGrey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: _buildFileOptionsButton(item),
            onTap: () => _openFile(item),
          ),
        );
      },
    );
  }

  // COMPLETELY REWRITTEN FILES TABLE - NO MORE OVERFLOW ISSUES
  Widget _buildFilesTable(List<DriveItem> items) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryPurple.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: primaryPurple.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: constraints.maxWidth,
              ),
              child: DataTable(
                columnSpacing: 16,
                horizontalMargin: 16,
                headingRowColor: WidgetStateProperty.all(purpleLight.withOpacity(0.3)),
                headingRowHeight: 48,
                dataRowHeight: 56,
                columns: const [
                  DataColumn(
                    label: SizedBox(
                      width: 200,
                      child: Text(
                        'Name',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: darkGrey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 150,
                      child: Text(
                        'Reason suggested',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: darkGrey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 120,
                      child: Text(
                        'Owner',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: darkGrey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: SizedBox(
                      width: 120,
                      child: Text(
                        'Location',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: darkGrey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataColumn(label: SizedBox(width: 40, child: Text(''))),
                ],
                rows: items.map((item) => DataRow(
                  cells: [
                    DataCell(
                      SizedBox(
                        width: 200,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _fileService.getFileIcon(item.type),
                              color: primaryPurple,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            if (item.type != DriveItemType.folder) ...[
                              const Icon(Icons.people, size: 16, color: mediumGrey),
                              const SizedBox(width: 8),
                            ],
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(fontSize: 14, color: darkGrey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 150,
                        child: Text(
                          '${item.reasonSuggested ?? 'Recently modified'} • ${item.lastModified}',
                          style: const TextStyle(fontSize: 14, color: mediumGrey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: item.owner == 'me'
                                  ? primaryPurple
                                  : mediumGrey,
                              child: Text(
                                item.owner?.substring(0, 1).toUpperCase() ?? 'U',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.owner ?? 'Unknown',
                                style: const TextStyle(fontSize: 14, color: darkGrey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.location?.contains('Shared') == true
                                  ? Icons.people
                                  : Icons.folder,
                              size: 16,
                              color: mediumGrey,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                item.location ?? '',
                                style: const TextStyle(fontSize: 14, color: darkGrey),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DataCell(
                      SizedBox(
                        width: 40,
                        child: _buildFileOptionsButton(item),
                      ),
                    ),
                  ],
                )).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFileOptionsButton(DriveItem item) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 20, color: mediumGrey),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'open',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.type == DriveItemType.folder ? Icons.folder_open : Icons.open_in_new,
                size: 18,
                color: mediumGrey,
              ),
              const SizedBox(width: 12),
              const Text('Open'),
            ],
          ),
        ),
        if (item.type != DriveItemType.folder)
          PopupMenuItem(
            value: 'open_with',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.apps, size: 18, color: mediumGrey),
                const SizedBox(width: 12),
                const Text('Open with'),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_right, size: 18, color: mediumGrey),
              ],
            ),
          ),
        const PopupMenuItem(
          value: 'download',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.download, size: 18, color: mediumGrey),
              SizedBox(width: 12),
              Text('Download'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'rename',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit, size: 18, color: mediumGrey),
              SizedBox(width: 12),
              Text('Rename'),
            ],
          ),
        ),
        if (selectedSection != 'Trash')
          const PopupMenuItem(
            value: 'move_to_trash',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, size: 18, color: mediumGrey),
                SizedBox(width: 12),
                Text('Move to trash'),
              ],
            ),
          ),
        if (selectedSection == 'Trash') ...[
          const PopupMenuItem(
            value: 'restore',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.restore, size: 18, color: primaryPurple),
                SizedBox(width: 12),
                Text('Restore', style: TextStyle(color: primaryPurple)),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'delete_forever',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete_forever, size: 18, color: Colors.red),
                SizedBox(width: 12),
                Text('Delete forever', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ],
      onSelected: (value) => _handleFileAction(value, item),
    );
  }

  void _handleFileAction(String action, DriveItem item) {
    switch (action) {
      case 'open':
        _openFile(item);
        break;
      case 'open_with':
        _showOpenWithOptions(item);
        break;
      case 'download':
        _downloadFile(item);
        break;
      case 'rename':
        _renameFile(item);
        break;
      case 'move_to_trash':
        _moveToTrash(item);
        break;
      case 'restore':
        _restoreFromTrash(item);
        break;
      case 'delete_forever':
        _deleteFromTrash(item);
        break;
    }
  }

  void _openFile(DriveItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${item.name}...'),
        backgroundColor: primaryPurple,
      ),
    );
  }

  void _showOpenWithOptions(DriveItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open with', style: TextStyle(color: darkGrey)),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.preview, color: primaryPurple),
                title: const Text('Google Docs Viewer'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening ${item.name} with Google Docs Viewer...'),
                      backgroundColor: primaryPurple,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.edit, color: primaryPurple),
                title: const Text('Google Docs'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening ${item.name} with Google Docs...'),
                      backgroundColor: primaryPurple,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.description, color: primaryPurple),
                title: const Text('External Editor'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Opening ${item.name} with external editor...'),
                      backgroundColor: primaryPurple,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: mediumGrey)),
          ),
        ],
      ),
    );
  }

  void _downloadFile(DriveItem item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading ${item.name}...'),
        backgroundColor: primaryPurple,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // Show download progress or location
          },
        ),
      ),
    );
  }

  void _renameFile(DriveItem item) async {
    String currentName = item.name;
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: currentName);
        return AlertDialog(
          title: const Text('Rename', style: TextStyle(color: darkGrey)),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryPurple.withOpacity(0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: primaryPurple, width: 2),
                ),
                labelText: 'Name',
                labelStyle: const TextStyle(color: mediumGrey),
              ),
              autofocus: true,
              onSubmitted: (value) => Navigator.pop(context, value),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: mediumGrey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Rename'),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty && result != currentName) {
      setState(() {
        // Update the item name in all relevant lists
        final updatedItem = item.copyWith(name: result);
        
        if (myDriveFiles.contains(item)) {
          final index = myDriveFiles.indexOf(item);
          myDriveFiles[index] = updatedItem;
        }
        
        if (recentFiles.contains(item)) {
          final index = recentFiles.indexOf(item);
          recentFiles[index] = updatedItem;
        }
        
        if (trashFiles.contains(item)) {
          final index = trashFiles.indexOf(item);
          trashFiles[index] = updatedItem;
        }
        
        _updateFilteredFiles();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Renamed to "$result"'),
            backgroundColor: primaryPurple,
          ),
        );
      }
    }
  }

  Widget _buildFilesView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return Column(
      children: [
        // Content Header - FIXED OVERFLOW
        Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectedSection,
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 32,
                    fontWeight: FontWeight.w400,
                    color: darkGrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.info_outline, color: mediumGrey),
                    tooltip: 'Details',
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.view_list, color: mediumGrey),
                    tooltip: 'List view',
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Files List/Grid
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: primaryPurple))
              : filteredFiles.isEmpty
                  ? _buildEmptyState()
                  : selectedSection == 'Recent' || isMobile
                      ? _buildRecentFilesView()
                      : _buildFilesGrid(),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    String message = selectedSection == 'Trash' 
        ? 'Trash is empty' 
        : 'No files found';
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selectedSection == 'Trash' 
                ? Icons.delete_outline 
                : Icons.folder_open,
            size: 64,
            color: lightGrey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: mediumGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentFilesView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: isMobile ? _buildMobileFileCards(filteredFiles) : _buildFilesTable(filteredFiles),
    );
  }

  // COMPLETELY RESPONSIVE FILES GRID
  Widget _buildFilesGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobile = screenWidth < 768;
        final isTablet = screenWidth < 1024 && screenWidth >= 768;
        
        int crossAxisCount;
        if (isMobile) {
          crossAxisCount = 2;
        } else if (isTablet) {
          crossAxisCount = 3;
        } else {
          crossAxisCount = (screenWidth / 200).floor().clamp(3, 6);
        }

        return GridView.builder(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: filteredFiles.length,
          itemBuilder: (context, index) {
            return _buildFileCard(filteredFiles[index]);
          },
        );
      },
    );
  }

  // RESPONSIVE FILE CARD
  Widget _buildFileCard(DriveItem item) {
    return Card(
      elevation: 3,
      shadowColor: primaryPurple.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _openFile(item),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.white, purpleLight.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    _fileService.getFileIcon(item.type),
                    size: 32,
                    color: primaryPurple,
                  ),
                  _buildFileOptionsButton(item),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: darkGrey,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (item.size.isNotEmpty) ...[
                      Text(
                        '${item.size} • ${item.lastModified}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: mediumGrey,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFileListItem(DriveItem item) {
    return ListTile(
      leading: Icon(
        _fileService.getFileIcon(item.type),
        color: primaryPurple,
      ),
      title: Text(
        item.name,
        style: const TextStyle(color: darkGrey),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        '${item.size} • ${item.lastModified}',
        style: const TextStyle(color: mediumGrey),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      trailing: _buildFileOptionsButton(item),
      onTap: () => _openFile(item),
    );
  }

  Widget _buildFilterButton(String text) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.keyboard_arrow_down, size: 16),
      label: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: mediumGrey,
        side: BorderSide(color: primaryPurple.withOpacity(0.3)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        minimumSize: const Size(0, 32),
      ),
    );
  }

  void _showNewMenu(BuildContext context) {
    final RenderBox? button = context.findRenderObject() as RenderBox?;
    if (button == null) return;
    
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(const Offset(0, 50), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      items: [
        PopupMenuItem(
          value: 'folder',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.create_new_folder, color: primaryPurple),
              const SizedBox(width: 12),
              const Text('New folder'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'upload_file',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.upload_file, color: primaryPurple),
              const SizedBox(width: 12),
              const Text('File upload'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'upload_folder',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.drive_folder_upload, color: primaryPurple),
              const SizedBox(width: 12),
              const Text('Folder upload'),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value != null) {
        _handleNewAction(value);
      }
    });
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
          title: const Text('New folder', style: TextStyle(color: darkGrey)),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryPurple.withOpacity(0.3)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: primaryPurple, width: 2),
                ),
              ),
              autofocus: true,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: mediumGrey)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPurple,
                foregroundColor: Colors.white,
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
        if (selectedSection == 'My Drive') {
          filteredFiles.insert(0, newFolder);
        }
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Folder "$result" created successfully'),
            backgroundColor: primaryPurple,
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
            recentFiles.insert(0, newFile.copyWith(reasonSuggested: 'You uploaded'));
            if (selectedSection == 'My Drive') {
              filteredFiles.insert(0, newFile);
            } else if (selectedSection == 'Recent') {
              filteredFiles.insert(0, newFile.copyWith(reasonSuggested: 'You uploaded'));
            }
          });
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${result.length} file(s) uploaded successfully'),
              backgroundColor: primaryPurple,
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
          if (selectedSection == 'My Drive') {
            filteredFiles.insert(0, newFolder);
          }
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Folder uploaded successfully'),
              backgroundColor: primaryPurple,
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
          ),
        );
      }
    }
  }

  void _moveToTrash(DriveItem item) {
    setState(() {
      myDriveFiles.remove(item);
      recentFiles.remove(item);
      trashFiles.add(item.copyWith(location: 'Trash'));
      _updateFilteredFiles();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Moved "${item.name}" to trash'),
        backgroundColor: primaryPurple,
        action: SnackBarAction(
          label: 'Undo',
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              trashFiles.remove(item.copyWith(location: 'Trash'));
              if (item.location == 'My Drive') {
                myDriveFiles.add(item);
              } else {
                recentFiles.add(item);
              }
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
        content: Text('Restored "${item.name}"'),
        backgroundColor: primaryPurple,
      ),
    );
  }

  void _deleteFromTrash(DriveItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete forever?', style: TextStyle(color: darkGrey)),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            'This will permanently delete "${item.name}". You cannot undo this action.',
            style: const TextStyle(color: mediumGrey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: mediumGrey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete forever'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        trashFiles.remove(item);
        _updateFilteredFiles();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permanently deleted "${item.name}"'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}