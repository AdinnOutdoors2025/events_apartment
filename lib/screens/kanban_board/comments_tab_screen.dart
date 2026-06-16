import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:external_path/external_path.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/order_details_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/snackbar.dart';
import '../../viewmodel/order_details_viewmodel.dart';
import '../../viewmodel/order_viewmodel.dart';
import '../kanban_board_screen.dart';
import 'package:record/record.dart';

const Color _grey = Color(0xff6B7280);
const Color _border = Color(0xffE5E7EB);
const Color _fieldBorder = Color(0xffD1D5DB);

class CommentsTab extends ConsumerStatefulWidget {
  final TextEditingController controller;
  final KanbanDeal deal;
  final KanbanStage stage;
  final OrderDetails details;

  const CommentsTab({
    super.key,
    required this.controller,
    required this.deal,
    required this.stage,
    required this.details,
  });

  @override
  ConsumerState<CommentsTab> createState() => _CommentsTabState();
}

class _CommentsTabState extends ConsumerState<CommentsTab> {
  final FocusNode _commentFocusNode = FocusNode();

  _PendingDocument? _document;
  _PendingVoice? _voice;
  bool _isPosting = false;

  bool get _canSend {
    return widget.controller.text.trim().isNotEmpty ||
        _document != null ||
        _voice != null;
  }

  @override
  void dispose() {
    _commentFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.single;

    setState(() {
      _document = _PendingDocument(
        name: file.name,
        size: file.size,
        path: file.path,
      );
    });
  }

  Future<void> _openVoiceRecorder() async {
    final voice = await showModalBottomSheet<_PendingVoice>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _VoiceRecorderSheet(),
    );

    if (voice == null) return;

    setState(() {
      _voice = voice;
    });
  }

  Future<void> _postComment() async {
    final comment = widget.controller.text.trim();

    if (!_canSend) {
      AppToast.showError("Please enter comment or add attachment");
      return;
    }

    setState(() => _isPosting = true);

    try {
      await ref
          .read(orderViewModelProvider.notifier)
          .updateOrderStatus(
            orderId: widget.deal.id,
            status: int.parse(widget.deal.stageId),
            additionalNotes: comment,
            statusDocument: _document != null
                ? PlatformFile(
                    name: _document!.name,
                    path: _document!.path,
                    size: _document!.size,
                  )
                : null,
            voiceDocument: _voice != null
                ? PlatformFile(
                    name: _voice!.path.split('/').last,
                    path: _voice!.path,
                    size: File(_voice!.path).lengthSync(),
                  )
                : null,
          );

      widget.controller.clear();

      setState(() {
        _document = null;
        _voice = null;
      });

      await ref
          .read(orderDetailsProvider(widget.deal.id).notifier)
          .getOrderDetails(widget.deal.id);
    } catch (_) {
      AppToast.showError("Unable to post comment");
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentHistory = _buildCommentFeed(widget.details.orderHistory ?? []);

    return Column(
      children: [
        _buildComposer(),
        const SizedBox(height: 12),
        _buildHistory(commentHistory),
      ],
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Add Comment",
                style: TextStyle(
                  color: Color(0xff111827),
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  widget.stage.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          TextField(
            controller: widget.controller,
            focusNode: _commentFocusNode,
            minLines: 3,
            maxLines: 4,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: "Type your comment here...",
              hintStyle: const TextStyle(
                color: Color(0xff9CA3AF),
                fontWeight: FontWeight.w600,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _fieldBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _fieldBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.red, width: 1.2),
              ),
            ),
          ),

          if (_document != null || _voice != null) ...[
            const SizedBox(height: 12),
            if (_document != null)
              _DocumentAttachmentView(
                fileName: _document!.name,
                fileSize: _formatFileSize(_document!.size),
                onRemove: () => setState(() => _document = null),
              ),
            if (_document != null && _voice != null) const SizedBox(height: 8),
            if (_voice != null)
              _VoiceAttachmentView(
                voiceUrl: _voice!.path,
                duration: _voice!.duration,
                onRemove: () => setState(() => _voice = null),
              ),
          ],

          const SizedBox(height: 14),

          Row(
            children: [
              _ComposerActionButton(
                label: "Aa",
                icon: null,
                color: Color(0xff111827),
                onTap: () => _commentFocusNode.requestFocus(),
              ),
              const SizedBox(width: 8),
              _ComposerActionButton(
                icon: Icons.attach_file_rounded,
                color: const Color(0xff2563EB),
                onTap: _pickDocument,
              ),
              const SizedBox(width: 8),
              _ComposerActionButton(
                icon: Icons.mic_rounded,
                color: const Color(0xff16A34A),
                onTap: _openVoiceRecorder,
              ),
              const Spacer(),
              SizedBox(
                height: 52,
                width: 70,
                child: ElevatedButton(
                  onPressed: _isPosting ? null : _postComment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.red.withOpacity(0.55),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isPosting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.send_rounded, size: 23),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistory(List<_CommentFeedItem> commentHistory) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Comments History",
            style: TextStyle(
              color: Color(0xff111827),
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 14),

          if (commentHistory.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 26),
                child: Text(
                  "No comments found",
                  style: TextStyle(color: _grey, fontWeight: FontWeight.w700),
                ),
              ),
            ),

          ...commentHistory.map((item) {
            return CommentItem(
              initials: item.initials,
              name: item.name,
              time: item.time,
              comment: item.comment,
              documents: item.documents,
              voiceNotes: item.voiceNotes,
              statusText: item.statusText,
            );
          }),
        ],
      ),
    );
  }
}

class _CommentFeedItem {
  final String key;
  String name;
  String time;
  String statusText;
  final List<String> comments;
  final List<_HistoryAttachment> documents;
  final List<_HistoryAttachment> voiceNotes;

  _CommentFeedItem({
    required this.key,
    required this.name,
    required this.time,
    required this.statusText,
    List<String>? comments,
    List<_HistoryAttachment>? documents,
    List<_HistoryAttachment>? voiceNotes,
  }) : comments = comments ?? [],
       documents = documents ?? [],
       voiceNotes = voiceNotes ?? [];

  String get comment => comments.join("\n").trim();

  String get initials {
    if (name.trim().isEmpty) return "NA";

    return name
        .trim()
        .split(" ")
        .where((e) => e.isNotEmpty)
        .take(2)
        .map((e) => e[0])
        .join()
        .toUpperCase();
  }
}

List<_CommentFeedItem> _buildCommentFeed(List<dynamic> histories) {
  final grouped = <String, _CommentFeedItem>{};

  for (final history in histories) {
    final fallbackName = history.changedBy ?? "-";
    final fallbackTime = history.changedAt?.toString() ?? "";

    final notes = _attachmentsList(history.additionalNotes);
    final statusDocs = _attachmentsList(history.statusDocument);
    final voiceDocs = _attachmentsList(history.voiceDocument);
    final historyStatusText = _historyStatusText(history);

    for (var i = 0; i < notes.length; i++) {
      final note = notes[i];
      final text = _readNoteText(note);

      if (text.trim().isEmpty) continue;

      final uploadedBy =
          _readAttachmentValue(note, ["uploadedBy"]) ?? fallbackName;

      final uploadedAt =
          _readAttachmentValue(note, ["uploadedAt"]) ?? "$fallbackTime-note-$i";

      final key = "$uploadedBy|$uploadedAt";

      final item = grouped.putIfAbsent(
        key,
        () => _CommentFeedItem(
          key: key,
          name: uploadedBy,
          time: uploadedAt,
          statusText: historyStatusText,
        ),
      );

      item.comments.add(text);
    }

    for (var i = 0; i < statusDocs.length; i++) {
      final doc = statusDocs[i];

      final uploadedBy =
          _readAttachmentValue(doc, ["uploadedBy"]) ?? fallbackName;

      final uploadedAt =
          _readAttachmentValue(doc, ["uploadedAt"]) ?? "$fallbackTime-doc-$i";

      final key = "$uploadedBy|$uploadedAt";

      final item = grouped.putIfAbsent(
        key,
        () => _CommentFeedItem(
          key: key,
          name: uploadedBy,
          time: uploadedAt,
          statusText: historyStatusText,
        ),
      );

      final url = _readAttachmentValue(doc, [
        "filePath",
        "filepath",
        "fileUrl",
        "url",
        "path",
      ]);

      if (url != null && url.isNotEmpty) {
        item.documents.add(
          _HistoryAttachment(
            name:
                _readAttachmentValue(doc, [
                  "originalName",
                  "fileName",
                  "filename",
                  "name",
                ]) ??
                "Document",
            url: url,
            size: _readAttachmentValue(doc, ["size"]),
          ),
        );
      }
    }

    for (var i = 0; i < voiceDocs.length; i++) {
      final voice = voiceDocs[i];

      final uploadedBy =
          _readAttachmentValue(voice, ["uploadedBy"]) ?? fallbackName;

      final uploadedAt =
          _readAttachmentValue(voice, ["uploadedAt"]) ??
          "$fallbackTime-voice-$i";

      final key = "$uploadedBy|$uploadedAt";

      final item = grouped.putIfAbsent(
        key,
        () => _CommentFeedItem(
          key: key,
          name: uploadedBy,
          time: uploadedAt,
          statusText: historyStatusText,
        ),
      );

      final url = _readAttachmentValue(voice, [
        "filePath",
        "filepath",
        "fileUrl",
        "url",
        "path",
      ]);

      if (url != null && url.isNotEmpty) {
        item.voiceNotes.add(
          _HistoryAttachment(
            name:
                _readAttachmentValue(voice, [
                  "originalName",
                  "fileName",
                  "filename",
                  "name",
                ]) ??
                "Voice note",
            url: url,
            size: _readAttachmentValue(voice, ["size"]),
            duration:
                _readAttachmentValue(voice, ["duration"]) ??
                _formatApiDuration(
                  _readAttachmentValue(voice, ["durationInSeconds"]),
                ),
            durationInSeconds: double.tryParse(
              _readAttachmentValue(voice, ["durationInSeconds"]) ?? "",
            ),
          ),
        );
      }
    }
  }

  final items = grouped.values.where((item) {
    return item.comment.isNotEmpty ||
        item.documents.isNotEmpty ||
        item.voiceNotes.isNotEmpty;
  }).toList();

  items.sort((a, b) {
    final dateA = DateTime.tryParse(a.time) ?? DateTime(2000);
    final dateB = DateTime.tryParse(b.time) ?? DateTime(2000);
    return dateB.compareTo(dateA);
  });

  return items;
}

String _historyStatusText(dynamic history) {
  final toStatusText = history.toStatusText?.toString().trim() ?? "";

  if (toStatusText.isNotEmpty) {
    return toStatusText;
  }

  final fromStatusText = history.fromStatusText?.toString().trim() ?? "";

  if (fromStatusText.isNotEmpty) {
    return fromStatusText;
  }

  return "";
}

String _readNoteText(dynamic note) {
  if (note == null) return "";

  if (note is String) return note;

  if (note is Map) {
    return note["text"]?.toString() ?? "";
  }

  try {
    return note.text?.toString() ?? "";
  } catch (_) {
    return "";
  }
}

class CommentItem extends StatelessWidget {
  final String initials;
  final String name;
  final String statusText;
  final String time;
  final String comment;

  final List<_HistoryAttachment> documents;
  final List<_HistoryAttachment> voiceNotes;

  const CommentItem({
    super.key,
    required this.initials,
    required this.name,
    required this.statusText,
    required this.time,
    required this.comment,

    required this.documents,
    required this.voiceNotes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 21,
            backgroundColor: const Color(0xffFEE2E2),
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.red,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff111827),
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      statusText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: const TextStyle(
                    color: _grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (comment.trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    comment,
                    style: const TextStyle(
                      color: Color(0xff111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ],

                if (documents.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ...documents.map((doc) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _DocumentAttachmentView(
                        fileName: doc.name,
                        fileSize: doc.size != null
                            ? _formatFileSize(int.tryParse(doc.size!) ?? 0)
                            : "Document",
                        fileUrl: doc.url,
                        onRemove: null,
                      ),
                    );
                  }),
                ],

                if (voiceNotes.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  ...voiceNotes.map((voice) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _VoiceAttachmentView(
                        voiceUrl: voice.url,
                        duration: voice.duration ?? "",
                        durationInSeconds: voice.durationInSeconds,
                        onRemove: null,
                      ),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ComposerActionButton extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final Color color;
  final VoidCallback onTap;

  const _ComposerActionButton({
    this.icon,
    this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        height: 46,
        width: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: _border),
        ),
        child: Center(
          child: icon == null
              ? Text(
                  label ?? "",
                  style: TextStyle(
                    color: color,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                )
              : Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

class _DocumentAttachmentView extends StatefulWidget {
  final String fileName;
  final String fileSize;
  final String? fileUrl;
  final VoidCallback? onRemove;

  const _DocumentAttachmentView({
    required this.fileName,
    required this.fileSize,
    this.fileUrl,
    required this.onRemove,
  });

  @override
  State<_DocumentAttachmentView> createState() =>
      _DocumentAttachmentViewState();
}

class _DocumentAttachmentViewState extends State<_DocumentAttachmentView> {
  bool _isDownloading = false;

  Future<void> _downloadToDownloads() async {
    if (widget.fileUrl == null || widget.fileUrl!.trim().isEmpty) {
      AppToast.showError("Document not available");
      return;
    }

    try {
      setState(() => _isDownloading = true);

      final hasPermission = await _requestStoragePermission();

      if (!hasPermission) {
        AppToast.showError("Storage permission required");
        return;
      }

      final fixedUrl = _fixLocalhostUrl(widget.fileUrl!.trim());

      final downloadsPath =
          await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOAD,
          );

      final safeName = _safeFileName(widget.fileName);
      final savePath = await _getUniqueFilePath(downloadsPath, safeName);

      await Dio().download(
        fixedUrl,
        savePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      AppToast.showSuccess("Downloaded to Downloads");
    } catch (e) {
      debugPrint("DOCUMENT DOWNLOAD ERROR => $e");
      AppToast.showError("Unable to download document");
    } finally {
      if (mounted) {
        setState(() => _isDownloading = false);
      }
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (!Platform.isAndroid) return true;
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }
    if (await Permission.storage.isGranted) {
      return true;
    }
    final storageResult = await Permission.storage.request();
    if (storageResult.isGranted) {
      return true;
    }
    final manageResult = await Permission.manageExternalStorage.request();
    if (manageResult.isGranted) {
      return true;
    }

    if (manageResult.isPermanentlyDenied || storageResult.isPermanentlyDenied) {
      await openAppSettings();
    }

    return false;
  }

  bool get _isImage {
    final name = widget.fileName.toLowerCase();
    return name.endsWith(".jpg") ||
        name.endsWith(".jpeg") ||
        name.endsWith(".png");
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.fileUrl == null
        ? null
        : _fixLocalhostUrl(widget.fileUrl!);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xffFFF7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffF3D2D2)),
      ),
      child: Column(
        children: [
          if (_isImage && imageUrl != null && imageUrl.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Container(
                    height: 90,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Image preview not available",
                      style: TextStyle(
                        color: _grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
          ],

          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _isImage ? Icons.image_rounded : Icons.picture_as_pdf_rounded,
                  color: Colors.white,
                  size: 21,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff111827),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.fileSize,
                      style: const TextStyle(
                        color: _grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.onRemove != null)
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.close_rounded, color: _grey),
                )
              else
                IconButton(
                  onPressed: _isDownloading ? null : _downloadToDownloads,
                  icon: _isDownloading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                          Icons.download_rounded,
                          color: _grey,
                          size: 22,
                        ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VoiceAttachmentView extends StatefulWidget {
  final String? voiceUrl;
  final String duration;
  final double? durationInSeconds;
  final VoidCallback? onRemove;

  const _VoiceAttachmentView({
    this.voiceUrl,
    required this.duration,
    this.durationInSeconds,
    required this.onRemove,
  });

  @override
  State<_VoiceAttachmentView> createState() => _VoiceAttachmentViewState();
}

class _VoiceAttachmentViewState extends State<_VoiceAttachmentView> {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;
  bool isLoading = false;
  Duration _position = Duration.zero;
  Duration? _totalDuration;

  String get displayDuration {
    if (isPlaying || _position > Duration.zero) {
      return _formatVoiceTime(_position);
    }

    if (_totalDuration != null) {
      return _formatVoiceTime(_totalDuration!);
    }

    return "--:--";
  }

  @override
  void initState() {
    super.initState();

    final apiSeconds = _getApiDurationSeconds(
      duration: widget.duration,
      durationInSeconds: widget.durationInSeconds,
    );

    if (apiSeconds != null) {
      _totalDuration = Duration(seconds: apiSeconds);
    }

    _player.onDurationChanged.listen((duration) {
      if (!mounted) return;

      setState(() {
        _totalDuration ??= duration;
      });
    });

    _player.onPositionChanged.listen((position) {
      if (!mounted) return;

      setState(() {
        _position = position;
      });
    });

    _player.onPlayerComplete.listen((_) {
      if (!mounted) return;

      setState(() {
        isPlaying = false;
        isLoading = false;
        _position = Duration.zero;
      });
    });

    if (_totalDuration == null) {
      _loadAudioDuration();
    }
  }

  Future<void> _loadAudioDuration() async {
    final source = widget.voiceUrl;

    if (source == null || source.trim().isEmpty) return;

    try {
      final playableSource = _fixLocalhostUrl(source.trim());

      if (_isNetworkFile(playableSource)) {
        await _player.setSource(UrlSource(playableSource));
      } else {
        final file = File(playableSource);

        if (!await file.exists()) {
          debugPrint("VOICE FILE NOT FOUND => $playableSource");
          return;
        }

        await _player.setSource(DeviceFileSource(playableSource));
      }

      final duration = await _player.getDuration();

      if (duration != null && mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    } catch (e) {
      debugPrint("Duration load error: $e");
    }
  }

  Future<void> _togglePlay() async {
    final source = widget.voiceUrl;

    if (source == null || source.trim().isEmpty) {
      AppToast.showError("Voice note not available");
      return;
    }

    try {
      final playableSource = _fixLocalhostUrl(source.trim());

      if (isPlaying) {
        await _player.pause();

        if (mounted) {
          setState(() => isPlaying = false);
        }

        return;
      }

      setState(() => isLoading = true);

      final total = _totalDuration;

      final canResume =
          _position > Duration.zero &&
          total != null &&
          _position.inSeconds < total.inSeconds;

      if (canResume) {
        await _player.resume();
      } else {
        await _player.stop();

        setState(() {
          _position = Duration.zero;
        });

        if (_isNetworkFile(playableSource)) {
          await _player.play(UrlSource(playableSource));
        } else {
          final file = File(playableSource);

          if (!await file.exists()) {
            AppToast.showError("Voice file not found");
            return;
          }

          await _player.play(DeviceFileSource(playableSource));
        }
      }

      if (mounted) {
        setState(() => isPlaying = true);
      }
    } catch (e) {
      debugPrint("VOICE PLAY ERROR => $e");
      AppToast.showError("Unable to play voice note");
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xffF0FDF4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffBBF7D0)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: isLoading ? null : _togglePlay,
            child: Icon(
              isPlaying
                  ? Icons.pause_circle_filled
                  : Icons.play_circle_fill_rounded,
              color: const Color(0xff16A34A),
              size: 34,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: _Waveform(color: Color(0xff16A34A))),
          const SizedBox(width: 8),
          Text(
            displayDuration,
            style: const TextStyle(
              color: Color(0xff111827),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (widget.onRemove != null)
            IconButton(
              onPressed: widget.onRemove,
              icon: const Icon(Icons.close_rounded, color: _grey),
            ),
        ],
      ),
    );
  }
}

class _VoiceRecorderSheet extends StatefulWidget {
  const _VoiceRecorderSheet();

  @override
  State<_VoiceRecorderSheet> createState() => _VoiceRecorderSheetState();
}

class _VoiceRecorderSheetState extends State<_VoiceRecorderSheet> {
  final AudioRecorder _recorder = AudioRecorder();

  Timer? _timer;
  bool _isRecording = false;
  bool _hasRecorded = false;
  int _seconds = 0;
  String? _recordedPath;

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final hasPermission = await _recorder.hasPermission();

    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Microphone permission required")),
      );
      return;
    }

    final dir = await getTemporaryDirectory();
    final path =
        "${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a";

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc),
      path: path,
    );

    setState(() {
      _isRecording = true;
      _hasRecorded = false;
      _seconds = 0;
      _recordedPath = path;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _seconds++);
      }
    });
  }

  Future<void> _stopRecording() async {
    final path = await _recorder.stop();

    _timer?.cancel();

    setState(() {
      _isRecording = false;
      _hasRecorded = true;
      _recordedPath = path ?? _recordedPath;
      if (_seconds == 0) _seconds = 1;
    });
  }

  void _useVoiceNote() {
    if (_recordedPath == null) return;

    Navigator.pop(
      context,
      _PendingVoice(path: _recordedPath!, duration: _formatDuration(_seconds)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 5,
              width: 46,
              decoration: BoxDecoration(
                color: const Color(0xffD1D5DB),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                const Text(
                  "Voice Note",
                  style: TextStyle(
                    color: Color(0xff111827),
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              height: 96,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: _isRecording
                    ? const Color(0xffFFF1F2)
                    : const Color(0xffF9FAFB),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isRecording ? const Color(0xffFECDD3) : _border,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _isRecording ? Icons.graphic_eq_rounded : Icons.mic_rounded,
                    color: _isRecording ? AppColors.red : _grey,
                    size: 32,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _Waveform(
                      color: _isRecording
                          ? AppColors.red
                          : const Color(0xff9CA3AF),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    _formatDuration(_seconds),
                    style: TextStyle(
                      color: _isRecording ? AppColors.red : Color(0xff111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            if (!_isRecording && !_hasRecorded)
              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _startRecording,
                  icon: const Icon(Icons.mic_rounded),
                  label: const Text("Start Recording"),
                  style: _redButtonStyle(),
                ),
              ),

            if (_isRecording)
              SizedBox(
                height: 54,
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _stopRecording,
                  icon: const Icon(Icons.stop_rounded),
                  label: const Text("Stop Recording"),
                  style: _redButtonStyle(),
                ),
              ),

            if (!_isRecording && _hasRecorded)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _startRecording,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text("Re-record"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Color(0xff111827),
                        side: const BorderSide(color: _border),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _useVoiceNote,
                      icon: const Icon(Icons.check_rounded),
                      label: const Text("Use Voice"),
                      style: _redButtonStyle(),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  ButtonStyle _redButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppColors.red,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      textStyle: const TextStyle(fontWeight: FontWeight.w900),
    );
  }
}

class _Waveform extends StatelessWidget {
  final Color color;

  const _Waveform({required this.color});

  @override
  Widget build(BuildContext context) {
    final heights = [8, 14, 20, 11, 26, 17, 9, 22, 13, 28, 16, 10, 21, 15];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: heights.map((height) {
        return Container(
          width: 3,
          height: height.toDouble(),
          decoration: BoxDecoration(
            color: color.withOpacity(0.55),
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }).toList(),
    );
  }
}

class _PendingDocument {
  final String name;
  final int size;
  final String? path;

  _PendingDocument({
    required this.name,
    required this.size,
    required this.path,
  });
}

class _PendingVoice {
  final String path;
  final String duration;

  _PendingVoice({required this.path, required this.duration});
}

String _formatFileSize(int bytes) {
  if (bytes < 1024) return "$bytes B";
  if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(1)} KB";
  return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
}

String _formatDuration(int seconds) {
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
}

String? _readAttachmentValue(dynamic item, List<String> keys) {
  if (item == null) return null;

  if (item is Map) {
    for (final key in keys) {
      final value = item[key];
      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    }
    return null;
  }

  for (final key in keys) {
    try {
      final dynamic value = switch (key) {
        "filePath" => item.filePath,
        "filepath" => item.filepath,
        "fileUrl" => item.fileUrl,
        "url" => item.url,
        "path" => item.path,
        "originalName" => item.originalName,
        "fileName" => item.fileName,
        "filename" => item.filename,
        "name" => item.name,
        "duration" => item.duration,
        "durationInSeconds" => item.durationInSeconds,
        "voiceDuration" => item.voiceDuration,
        "text" => item.text,
        "uploadedBy" => item.uploadedBy,
        "uploadedAt" => item.uploadedAt,

        _ => null,
      };

      if (value != null && value.toString().trim().isNotEmpty) {
        return value.toString();
      }
    } catch (_) {}
  }

  return null;
}

class _HistoryAttachment {
  final String name;
  final String? url;
  final String? size;
  final String? duration;
  final double? durationInSeconds;

  _HistoryAttachment({
    required this.name,
    required this.url,
    this.size,
    this.duration,
    this.durationInSeconds,
  });
}

List<dynamic> _attachmentsList(dynamic value) {
  if (value == null) return [];

  if (value is List) {
    return value;
  }

  if (value is Map) {
    return [value];
  }

  return [value];
}

bool _isNetworkFile(String value) {
  return value.startsWith("http://") || value.startsWith("https://");
}

/*String _fixLocalhostUrl(String url) {
  if (url.isEmpty) return url;

  if (Platform.isAndroid && url.contains("localhost")) {
    return url.replaceAll("localhost", "192.168.0.11");
  }

  return url;
}*/
String _fixLocalhostUrl(String url) {
  return url;
}

String _safeFileName(String fileName) {
  return fileName.replaceAll(RegExp(r'[\\/:*?"<>|]'), "_");
}

Future<String> _getUniqueFilePath(String folderPath, String fileName) async {
  final originalPath = "$folderPath/$fileName";

  if (!await File(originalPath).exists()) {
    return originalPath;
  }

  final dotIndex = fileName.lastIndexOf(".");

  final nameWithoutExt = dotIndex == -1
      ? fileName
      : fileName.substring(0, dotIndex);

  final extension = dotIndex == -1 ? "" : fileName.substring(dotIndex);

  var count = 1;

  while (true) {
    final newPath = "$folderPath/$nameWithoutExt($count)$extension";

    if (!await File(newPath).exists()) {
      return newPath;
    }

    count++;
  }
}

String? _formatApiDuration(String? value) {
  if (value == null || value.trim().isEmpty) return null;

  final secondsDouble = double.tryParse(value);

  if (secondsDouble == null) return null;

  final seconds = secondsDouble.round();

  if (seconds < 60) {
    return "$seconds sec";
  }

  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;

  return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
}

int? _getApiDurationSeconds({
  required String duration,
  required double? durationInSeconds,
}) {
  if (durationInSeconds != null) {
    return durationInSeconds.floor();
  }

  final text = duration.trim().toLowerCase();

  if (text.isEmpty || text == "--:--") return null;

  final secMatch = RegExp(r'(\d+(\.\d+)?)\s*sec').firstMatch(text);

  if (secMatch != null) {
    final value = double.tryParse(secMatch.group(1) ?? "");
    return value?.floor();
  }

  final clockMatch = RegExp(r'^(\d+):(\d{1,2})$').firstMatch(text);

  if (clockMatch != null) {
    final minutes = int.tryParse(clockMatch.group(1) ?? "0") ?? 0;
    final seconds = int.tryParse(clockMatch.group(2) ?? "0") ?? 0;
    return (minutes * 60) + seconds;
  }

  return null;
}

String _formatVoiceTime(Duration duration) {
  final totalSeconds = duration.inSeconds;
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;

  return "$minutes:${seconds.toString().padLeft(2, '0')}";
}

BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: _border),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.035),
        blurRadius: 14,
        offset: const Offset(0, 6),
      ),
    ],
  );
}
