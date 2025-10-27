import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:plan_z/features/vendor_features/packages_mangment/data/repos/i_vendor_repository.dart';
import '../models/vendor_model.dart';
import '../models/package_model.dart';
import '../models/notification_model.dart';

class VendorRepositoryImpl implements IVendorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference get _vendorsCollection =>
      _firestore.collection('vendors');

  CollectionReference get _packagesCollection =>
      _firestore.collection('packages');

  CollectionReference get _notificationsCollection =>
      _firestore.collection('notifications');

  // -------------------------
  // Vendor Operations
  // -------------------------
  @override
  Future<void> addVendor(VendorModel vendor) async {
    await _vendorsCollection.doc(vendor.vendorId).set(vendor.toMap());
  }

  @override
  Future<void> updateVendor(VendorModel vendor) async {
    await _vendorsCollection.doc(vendor.vendorId).update(vendor.toMap());
  }

  @override
  Future<void> deleteVendor(String vendorId) async {
    await _vendorsCollection.doc(vendorId).delete();
  }

  @override
  Future<VendorModel?> getVendorById(String vendorId) async {
    final snapshot = await _vendorsCollection.doc(vendorId).get();
    if (snapshot.exists) {
      return VendorModel.fromMap(
        snapshot.data() as Map<String, dynamic>,
        snapshot.id,
      );
    }
    return null;
  }

  // -------------------------
  // Package Operations
  // -------------------------
  @override
  Future<void> addPackage(PackageModel package) async {
    await _packagesCollection.doc(package.packageId).set(package.toMap());
  }

  @override
  Future<void> updatePackage(PackageModel package) async {
    await _packagesCollection.doc(package.packageId).update(package.toMap());
  }

  @override
  Future<void> deletePackage(String packageId) async {
    await _packagesCollection.doc(packageId).delete();
  }

  @override
  Future<List<PackageModel>> getVendorPackages(String vendorId) async {
    final snapshot = await _packagesCollection
        .where('vendorId', isEqualTo: vendorId)
        .get();

    return snapshot.docs
        .map((doc) => PackageModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  // -------------------------
  // Notification Operations
  // -------------------------
  @override
  Future<void> sendNotificationToVendor(
    String vendorId,
    NotificationModel notification,
  ) async {
    await _notificationsCollection
        .doc(notification.notificationId)
        .set(notification.toMap());
  }

  @override
  Future<List<NotificationModel>> getVendorNotifications(
    String vendorId,
  ) async {
    final snapshot = await _notificationsCollection
        .where('vendorId', isEqualTo: vendorId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map(
          (doc) => NotificationModel.fromMap(
            doc.data() as Map<String, dynamic>,
            doc.id,
          ),
        )
        .toList();
  }
}
