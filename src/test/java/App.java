import java.util.ArrayList;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class User {
    String name;

    public User(String name) {
        this.name = name;
    }
}

class Movie {
    String title;
    String genre;

    public Movie(String title, String genre) {
        this.title = title;
        this.genre = genre;
    }
}

class Review {
    User user;
    Movie movie;
    int rating;
    String comment;

    public Review(User user, Movie movie, int rating, String comment) {
        this.user = user;
        this.movie = movie;
        this.rating = rating;
        this.comment = comment;
    }

    @Override
    public String toString() {
        return user.name + " reviewed " + movie.title + " (" + movie.genre + ") with rating " + rating + ": " + comment;
    }
}

class Login {
    private static final String DUMMY_USERNAME = "admin";
    private static final String DUMMY_PASSWORD = "password123";

    public boolean authenticate(String username, String password) {
        return DUMMY_USERNAME.equals(username) && DUMMY_PASSWORD.equals(password);
    }
}

public class App {
    ArrayList<User> users;
    ArrayList<Movie> movies;
    ArrayList<Review> reviews;

    public App() {
        this.users = new ArrayList<>();
        this.movies = new ArrayList<>();
        this.reviews = new ArrayList<>();
    }

    public User addUser(String name) {
        User user = new User(name);
        users.add(user);
        return user;
    }

    public Movie addMovie(String title, String genre) {
        Movie movie = new Movie(title, genre);
        movies.add(movie);
        return movie;
    }

    public Review addReview(User user, Movie movie, int rating, String comment) {
        Review review = new Review(user, movie, rating, comment);
        reviews.add(review);
        return review;
    }

    public static void main(String[] args) {
        App app = new App();

        User user1 = app.addUser("Alice");

        Movie movie1 = app.addMovie("Inception", "Sci-Fi");

        Review review1 = app.addReview(user1, movie1, 5, "Amazing movie!");

        System.out.println(review1);
    }
}

// JUnit Test Cases
class UserTest {
    @Test
    void testCreateUser() {
        User user = new User("Alice");
        assertEquals("Alice", user.name);
    }

    @Test
    void testUserNotNull() {
        User user = new User("Bob");
        assertNotNull(user);
    }

    @Test
    void testUserNameChange() {
        User user = new User("Charlie");
        user.name = "CharlieUpdated";
        assertEquals("CharlieUpdated", user.name);
    }

    @Test
    void testUserNameIsString() {
        User user = new User("David");
        assertTrue(user.name instanceof String);
    }

    @Test
    void testUserDifferentNames() {
        User user1 = new User("Eve");
        User user2 = new User("Frank");
        assertNotEquals(user1.name, user2.name);
    }
}

class MovieTest {
    @Test
    void testCreateMovie() {
        Movie movie = new Movie("Titanic", "Drama");
        assertEquals("Titanic", movie.title);
    }

    @Test
    void testMovieGenre() {
        Movie movie = new Movie("Avatar", "Sci-Fi");
        assertEquals("Sci-Fi", movie.genre);
    }

    @Test
    void testMovieTitleNotNull() {
        Movie movie = new Movie("Interstellar", "Sci-Fi");
        assertNotNull(movie.title);
    }

    @Test
    void testMovieGenreNotNull() {
        Movie movie = new Movie("Inception", "Sci-Fi");
        assertNotNull(movie.genre);
    }

    @Test
    void testDifferentMovies() {
        Movie movie1 = new Movie("Gladiator", "Action");
        Movie movie2 = new Movie("Toy Story", "Animation");
        assertNotEquals(movie1.title, movie2.title);
    }
}

class ReviewTest {
    @Test
    void testCreateReview() {
        User user = new User("Alice");
        Movie movie = new Movie("Inception", "Sci-Fi");
        Review review = new Review(user, movie, 5, "Amazing!");
        assertNotNull(review);
    }

    @Test
    void testReviewRating() {
        User user = new User("Bob");
        Movie movie = new Movie("Titanic", "Drama");
        Review review = new Review(user, movie, 4, "Great movie!");
        assertEquals(4, review.rating);
    }

    @Test
    void testReviewComment() {
        User user = new User("Charlie");
        Movie movie = new Movie("Avatar", "Sci-Fi");
        Review review = new Review(user, movie, 5, "Best ever!");
        assertEquals("Best ever!", review.comment);
    }

    @Test
    void testReviewUserNotNull() {
        User user = new User("David");
        Movie movie = new Movie("Gladiator", "Action");
        Review review = new Review(user, movie, 5, "Awesome!");
        assertNotNull(review.user);
    }

    @Test
    void testReviewMovieNotNull() {
        User user = new User("Eve");
        Movie movie = new Movie("Toy Story", "Animation");
        Review review = new Review(user, movie, 3, "Fun!");
        assertNotNull(review.movie);
    }
}

class LoginTest {
    @Test
    void testCorrectLogin() {
        Login login = new Login();
        assertTrue(login.authenticate("admin", "password123"));
    }

    @Test
    void testIncorrectUsername() {
        Login login = new Login();
        assertFalse(login.authenticate("wrongUser", "password123"));
    }

    @Test
    void testIncorrectPassword() {
        Login login = new Login();
        assertFalse(login.authenticate("admin", "wrongPassword"));
    }

    @Test
    void testBothIncorrect() {
        Login login = new Login();
        assertFalse(login.authenticate("wrongUser", "wrongPassword"));
    }

    @Test
    void testEmptyCredentials() {
        Login login = new Login();
        assertFalse(login.authenticate("", ""));
    }
}

class AppTest {
    @Test
    void testAddUser() {
        App app = new App();
        User user = app.addUser("Alice");
        assertEquals("Alice", user.name);
    }

    @Test
    void testAddMovie() {
        App app = new App();
        Movie movie = app.addMovie("Inception", "Sci-Fi");
        assertEquals("Inception", movie.title);
    }

    @Test
    void testAddReview() {
        App app = new App();
        User user = app.addUser("Alice");
        Movie movie = app.addMovie("Inception", "Sci-Fi");
        Review review = app.addReview(user, movie, 5, "Amazing movie!");
        assertEquals(5, review.rating);
    }

    @Test
    void testMovieListSize() {
        App app = new App();
        app.addMovie("Avatar", "Sci-Fi");
        assertEquals(1, app.movies.size());
    }

    @Test
    void testUserListSize() {
        App app = new App();
        app.addUser("Charlie");
        assertEquals(1, app.users.size());
    }
}
