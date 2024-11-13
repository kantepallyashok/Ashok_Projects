import { render, screen } from '@testing-library/react';
import App from '../App';  // Adjust the import path based on your project structure

test('renders the frontend correctly', () => {
  render(<App />);
  const linkElement = screen.getByText(/learn react/i);  // Replace with something specific from your app
  expect(linkElement).toBeInTheDocument();
});
