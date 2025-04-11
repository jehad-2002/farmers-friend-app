import 'package:farmersfriendapp/core/enums/filter_type.dart';
import 'package:farmersfriendapp/core/errors/failures.dart';
import 'package:farmersfriendapp/core/models/guideline.dart';
import 'package:farmersfriendapp/core/models/guideline_with_images.dart';
import 'package:farmersfriendapp/core/presentation/widgets/crop_selection_dropdown.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_app_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/custom_search_bar.dart';
import 'package:farmersfriendapp/core/presentation/widgets/empty_list_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/error_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/loading_indicator.dart';
import 'package:farmersfriendapp/core/presentation/widgets/shared_filter_bar.dart';
import 'package:farmersfriendapp/core/service_locator.dart';
import 'package:farmersfriendapp/core/utils/app_constants.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/delete_guideline.dart';
import 'package:farmersfriendapp/features/guideline/domain/usecases/get_guidelines_with_images.dart';
import 'package:farmersfriendapp/features/guideline/presentation/pages/guideline_detail_page.dart';
import 'package:farmersfriendapp/features/guideline/presentation/pages/manage_guideline_page.dart';
import 'package:farmersfriendapp/features/guideline/presentation/widgets/guideline_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GuidelineListPage extends StatefulWidget {
  final int? userId;

  const GuidelineListPage({Key? key, this.userId}) : super(key: key);

  bool get isAdminView => userId != null && userId! > 0;

  @override
  State<GuidelineListPage> createState() => _GuidelineListPageState();
}

class _GuidelineListPageState extends State<GuidelineListPage> {
  List<GuidelineWithImages> _allGuidelines = [];
  List<GuidelineWithImages> _displayGuidelines = [];

  bool _isLoading = true;
  String? _errorMessage;
  FilterType _currentFilterType = FilterType.none;
  int? _selectedCropIdForFilter;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  late final GetGuidelinesWithImages _getAllGuidelinesWithImages;
  late final DeleteGuideline _deleteGuideline;

  @override
  void initState() {
    super.initState();
    _getAllGuidelinesWithImages = sl.getGuidelinesWithImages;
    _deleteGuideline = sl.deleteGuideline;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData({bool showLoading = true}) async {
    if (!mounted) return;

    if (showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final guidelinesResult = await _getAllGuidelinesWithImages();
      if (!mounted) return;

      guidelinesResult.fold((failure) => throw failure, (guidelines) {
        _allGuidelines = guidelines;
        _applyFiltersAndSort();
      });

      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = (e is Failure)
              ? e.getLocalizedMessage(context)
              : AppLocalizations.of(context)!.errorLoadingData;
          _allGuidelines = [];
          _displayGuidelines = [];
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _applyFiltersAndSort() {
    if (!mounted) return;
    List<GuidelineWithImages> result = List.from(_allGuidelines);

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      result = result
          .where((item) =>
              item.guideline.title.toLowerCase().contains(query) ||
              item.guideline.guidanceText.toLowerCase().contains(query))
          .toList();
    }

    if (_currentFilterType == FilterType.filterByCrop &&
        _selectedCropIdForFilter != null) {
      result = result
          .where((item) => item.guideline.cropId == _selectedCropIdForFilter)
          .toList();
    }

    switch (_currentFilterType) {
      case FilterType.sortByDateNewestFirst:
        result.sort((a, b) => (b.guideline.publicationDate ?? '')
            .compareTo(a.guideline.publicationDate ?? ''));
        break;
      case FilterType.sortByDateOldestFirst:
        result.sort((a, b) => (a.guideline.publicationDate ?? '')
            .compareTo(b.guideline.publicationDate ?? ''));
        break;
      default:
        result.sort((a, b) => (b.guideline.publicationDate ?? '')
            .compareTo(a.guideline.publicationDate ?? ''));
        break;
    }
    setState(() {
      _displayGuidelines = result;
    });
  }

  void _onSearchChanged(String query) {
    if (_searchQuery != query) {
      setState(() => _searchQuery = query);
      _applyFiltersAndSort();
    }
  }

  void _onFilterTypeChanged(FilterType? filterType) {
    final newFilter = filterType ?? FilterType.none;
    if (newFilter != _currentFilterType) {
      setState(() {
        _currentFilterType = newFilter;
        if (_currentFilterType != FilterType.filterByCrop) {
          _selectedCropIdForFilter = null;
        }
        _applyFiltersAndSort();
      });
    }
  }

  void _onCropSelectedForFilter(int? cropId) {
    if (_currentFilterType == FilterType.filterByCrop &&
        cropId != _selectedCropIdForFilter) {
      setState(() {
        _selectedCropIdForFilter = cropId;
        _applyFiltersAndSort();
      });
    }
  }

  Future<void> _navigateManageGuideline({Guideline? guideline}) async {
    if (!widget.isAdminView) return;
    final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(
            builder: (_) => ManageGuidelinePage(guideline: guideline)));
    if (result == true && mounted) {
      _loadInitialData(showLoading: false);
    }
  }

  void _navigateToDetail(Guideline guideline) {
    if (guideline.guidanceId != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  GuidelineDetailPage(guidelineId: guideline.guidanceId!)));
    }
  }

  Future<void> _handleDeleteGuideline(Guideline guideline) async {
    if (!widget.isAdminView || guideline.guidanceId == null) return;
    try {
      final result = await _deleteGuideline(guideline.guidanceId!);
      if (!mounted) return;
      result.fold(
          (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(f.getLocalizedMessage(context)),
              backgroundColor: AppConstants.errorColor)), (_) {
        setState(() {
          _allGuidelines.removeWhere(
              (g) => g.guideline.guidanceId == guideline.guidanceId);
          _applyFiltersAndSort();
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context)!.guidelineDeletedSuccessfully),
            backgroundColor: AppConstants.successColor));
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                AppLocalizations.of(context)!.unexpectedError(e.toString())),
            backgroundColor: AppConstants.errorColor));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: widget.isAdminView
          ? CustomAppBar(
              title: localizations.manageGuidelines,
              iconTheme: IconThemeData(color: theme.colorScheme.onPrimary),
              backgroundColor: theme.colorScheme.primary,
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () => _loadInitialData(showLoading: false),
        color: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.background,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.defaultPadding,
                vertical: AppConstants.smallPadding,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomSearchBar(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      hintText: localizations.searchGuidelines,
                      enabled: !_isLoading,
                    ),
                  ),
                  const SizedBox(width: AppConstants.smallPadding),
                  SharedFilterBar(
                    currentFilter: _currentFilterType,
                    onFilterChanged: _onFilterTypeChanged,
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: AppConstants.shortAnimationDuration,
              child: Visibility(
                visible: _currentFilterType == FilterType.filterByCrop &&
                    !_isLoading,
                maintainState: true,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                    vertical: AppConstants.smallPadding / 2,
                  ),
                  child: CropSelectionDropdown(
                    initialValue: _selectedCropIdForFilter,
                    labelText: localizations.filterByCrop,
                    enabled: !_isLoading,
                    onChanged: _onCropSelectedForFilter,
                    validator: null,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _buildContentBody(context, localizations),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.isAdminView
          ? FloatingActionButton(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              tooltip: localizations.addGuideline,
              onPressed: _isLoading ? null : () => _navigateManageGuideline(),
              child: const Icon(AppConstants.addIcon),
            )
          : null,
    );
  }

  Widget _buildContentBody(
      BuildContext context, AppLocalizations localizations) {
    final theme = Theme.of(context);

    if (_isLoading) return const LoadingIndicator(isCentered: true);
    if (_errorMessage != null) {
      return ErrorIndicator(message: _errorMessage!, onRetry: _loadInitialData);
    }

    if (_displayGuidelines.isEmpty) {
      final message = _searchQuery.isNotEmpty ||
              (_currentFilterType == FilterType.filterByCrop &&
                  _selectedCropIdForFilter != null)
          ? localizations.noMatchingGuidelinesFound
          : localizations.noGuidelinesFound;
      return EmptyListIndicator(
        message: message,
        icon: AppConstants.guidelineIcon,
      );
    }

    return CustomGuidelineGrid(
      guidelinesWithImages: _displayGuidelines,
      showAdminActions: widget.isAdminView,
      onGuidelineTap: _navigateToDetail,
      onEditTap: (guideline) {
        _navigateManageGuideline(guideline: guideline);
      },
      onDeleteTap: _handleDeleteGuideline,
      isLoading: _isLoading,
      errorMessage: _errorMessage,
      onRetry: _loadInitialData,
    );
  }
}
