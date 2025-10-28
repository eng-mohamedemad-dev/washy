import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

/// Notes section widget for adding notes, photos, and audio recordings
/// Matches the notes and file upload functionality in Java NewOrderActivity
class NotesSection extends StatefulWidget {
  final Map<String, dynamic> data;
  final Function(Map<String, dynamic>) onChanged;

  const NotesSection({
    Key? key,
    required this.data,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<NotesSection> createState() => _NotesSectionState();
}

class _NotesSectionState extends State<NotesSection> {
  String orderNotes = '';
  List<File> uploadedPhotos = [];
  File? uploadedAudio;
  
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    orderNotes = widget.data['notes'] ?? '';
    uploadedPhotos = widget.data['uploadedPhotos'] ?? [];
    uploadedAudio = widget.data['uploadedAudio'];
    
    _notesController.text = orderNotes;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notes text area
          _buildNotesInput(),
          
          const SizedBox(height: 20),
          
          // Photo attachments
          _buildPhotoSection(),
          
          const SizedBox(height: 20),
          
          // Audio recording
          _buildAudioSection(),
        ],
      ),
    );
  }

  /// Build notes input field
  Widget _buildNotesInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ملاحظات إضافية',
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        
        const SizedBox(height: 8),
        
        TextField(
          controller: _notesController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'أضف أي ملاحظات خاصة بطلبك هنا...',
            hintStyle: const TextStyle(
              color: AppColors.grey,
              fontSize: 14,
              fontFamily: 'Cairo',
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.washyGreen),
            ),
            filled: true,
            fillColor: AppColors.white,
            contentPadding: const EdgeInsets.all(12),
          ),
          onChanged: (value) {
            orderNotes = value;
            _notifyChange();
          },
        ),
      ],
    );
  }

  /// Build photo attachments section
  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'الصور المرفقة',
              style: TextStyle(
                color: AppColors.darkGrey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            const Spacer(),
            Text(
              '${uploadedPhotos.length}/5',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 12,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Photo grid
        if (uploadedPhotos.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: uploadedPhotos.length,
            itemBuilder: (context, index) {
              return _buildPhotoThumbnail(uploadedPhotos[index], index);
            },
          ),
        
        const SizedBox(height: 8),
        
        // Add photo button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: uploadedPhotos.length < 5 ? _addPhoto : null,
            icon: Icon(
              Icons.add_a_photo,
              color: uploadedPhotos.length < 5 
                  ? AppColors.washyGreen 
                  : AppColors.lightGrey,
              size: 20,
            ),
            label: Text(
              'إضافة صورة',
              style: TextStyle(
                color: uploadedPhotos.length < 5 
                    ? AppColors.washyGreen 
                    : AppColors.lightGrey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: uploadedPhotos.length < 5 
                    ? AppColors.washyGreen 
                    : AppColors.lightGrey,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  /// Build photo thumbnail with delete option
  Widget _buildPhotoThumbnail(File photo, int index) {
    return Stack(
      children: [
        // Photo preview
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              photo,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.lightGrey.withOpacity(0.3),
                  child: const Icon(
                    Icons.image,
                    color: AppColors.grey,
                    size: 32,
                  ),
                );
              },
            ),
          ),
        ),
        
        // Delete button
        Positioned(
          top: 4,
          right: 4,
          child: InkWell(
            onTap: () => _removePhoto(index),
            child: Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              child: const Icon(
                Icons.close,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Build audio recording section
  Widget _buildAudioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تسجيل صوتي',
          style: TextStyle(
            color: AppColors.darkGrey,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Audio player/recorder
        if (uploadedAudio != null)
          _buildAudioPlayer()
        else
          _buildAudioRecorder(),
      ],
    );
  }

  /// Build audio player widget
  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.washyGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.washyGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          // Play button
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.washyGreen,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: AppColors.white,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Audio info
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تسجيل صوتي',
                  style: TextStyle(
                    color: AppColors.darkGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  '00:45',
                  style: TextStyle(
                    color: AppColors.grey,
                    fontSize: 12,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          
          // Delete button
          InkWell(
            onTap: _removeAudio,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.1),
              ),
              child: const Icon(
                Icons.delete,
                color: Colors.red,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build audio recorder widget
  Widget _buildAudioRecorder() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _recordAudio,
        icon: const Icon(
          Icons.mic,
          color: AppColors.washyGreen,
          size: 20,
        ),
        label: const Text(
          'تسجيل ملاحظة صوتية',
          style: TextStyle(
            color: AppColors.washyGreen,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.washyGreen),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  /// Add photo
  void _addPhoto() {
    // TODO: Implement photo picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('إضافة الصور قيد التطوير'),
        backgroundColor: AppColors.washyGreen,
      ),
    );
  }

  /// Remove photo
  void _removePhoto(int index) {
    setState(() {
      uploadedPhotos.removeAt(index);
    });
    _notifyChange();
  }

  /// Record audio
  void _recordAudio() {
    // TODO: Implement audio recording
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('التسجيل الصوتي قيد التطوير'),
        backgroundColor: AppColors.washyGreen,
      ),
    );
  }

  /// Remove audio
  void _removeAudio() {
    setState(() {
      uploadedAudio = null;
    });
    _notifyChange();
  }

  /// Notify parent about changes
  void _notifyChange() {
    widget.onChanged({
      'notes': orderNotes,
      'uploadedPhotos': uploadedPhotos,
      'uploadedAudio': uploadedAudio,
    });
  }
}
