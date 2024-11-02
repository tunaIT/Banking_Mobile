import React from 'react';
import { View, Text, Image, FlatList, StyleSheet } from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

const App = () => {
    // Danh sách các mục menu
    const menuItems = [
        { title: 'Account and Card', icon: 'account-balance' },
        { title: 'Transfer', icon: 'swap-horiz' },
        { title: 'Withdraw', icon: 'attach-money' },
        { title: 'Mobile prepaid', icon: 'phone-android' },
        { title: 'Pay the bill', icon: 'receipt' },
        { title: 'Save online', icon: 'cloud' },
        { title: 'Credit card', icon: 'credit-card' },
        { title: 'Transaction report', icon: 'bar-chart' },
        { title: 'Beneficiary', icon: 'group' },
    ];

    // Thành phần cho mỗi mục menu
    const renderMenuItem = ({ item }) => (
        <View style={styles.menuItem}>
            <Icon name={item.icon} size={30} color="#4A00E0" />
            <Text style={styles.menuItemText}>{item.title}</Text>
        </View>
    );

    return (
        <View style={styles.container}>
            {/* Header */}
            <View style={styles.header}>
                <Image
                    source={{ uri: 'https://via.placeholder.com/40' }}
                    style={styles.profileImage}
                />
                <Text style={styles.greetingText}>Hi, Push Puttichai</Text>
                <View style={styles.notificationContainer}>
                    <Icon name="notifications" size={24} color="#FFFFFF" />
                    <View style={styles.notificationBadge}>
                        <Text style={styles.notificationText}>3</Text>
                    </View>
                </View>
            </View>

            {/* Card */}
            <View style={styles.card}>
                <Text style={styles.cardName}>John Smith</Text>
                <Text style={styles.cardType}>Amazon Platinium</Text>
                <Text style={styles.cardNumber}>4756 **** **** 9018</Text>
                <Text style={styles.cardBalance}>$3,469.52</Text>
            </View>

            {/* Menu Grid */}
            <FlatList
                data={menuItems}
                renderItem={renderMenuItem}
                keyExtractor={(item) => item.title}
                numColumns={3}
                contentContainerStyle={styles.menuGrid}
            />
        </View>
    );
};

export default App;

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#F5F5F5',
    },
    header: {
        flexDirection: 'row',
        alignItems: 'center',
        backgroundColor: '#4A00E0',
        padding: 16,
    },
    profileImage: {
        width: 40,
        height: 40,
        borderRadius: 20,
        marginRight: 8,
    },
    greetingText: {
        flex: 1,
        color: '#FFFFFF',
        fontSize: 16,
    },
    notificationContainer: {
        position: 'relative',
    },
    notificationBadge: {
        position: 'absolute',
        top: -5,
        right: -5,
        backgroundColor: '#FF3D00',
        borderRadius: 10,
        padding: 2,
        paddingHorizontal: 5,
    },
    notificationText: {
        color: '#FFFFFF',
        fontSize: 10,
    },
    card: {
        backgroundColor: '#4A00E0',
        borderRadius: 12,
        padding: 16,
        margin: 16,
        elevation: 5,
    },
    cardName: {
        color: '#FFFFFF',
        fontSize: 18,
    },
    cardType: {
        color: '#E0E0E0',
        fontSize: 14,
        marginVertical: 4,
    },
    cardNumber: {
        color: '#E0E0E0',
        fontSize: 14,
        marginVertical: 4,
    },
    cardBalance: {
        color: '#FFFFFF',
        fontSize: 24,
        marginTop: 8,
    },
    menuGrid: {
        padding: 16,
    },
    menuItem: {
        flex: 1,
        alignItems: 'center',
        padding: 16,
        margin: 4,
        borderRadius: 8,
        backgroundColor: '#FFFFFF',
        elevation: 3,
    },
    menuItemText: {
        marginTop: 8,
        fontSize: 12,
        color: '#333333',
        textAlign: 'center',
    },
});